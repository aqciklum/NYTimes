//
//  NYTArticleRepositoryTests 2.swift
//  NYTimesApp
//
//  Created by Abdul Qadar on 30/8/2025.
//
import XCTest
@testable import NYTimesApp

// MARK: - Repository Tests (Testing Mock Repository)
class MockArticleRepositoryTests: XCTestCase {
    
    var mockRepository: MockArticleRepository!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockArticleRepository()
    }
    
    override func tearDown() {
        mockRepository = nil
        super.tearDown()
    }
    
    func testFetchArticlesSuccess() async {
        // Given
        let mockArticle = Article(
            url: "https://nytimes.com/article1",
            id: 123,
            source: "The New York Times",
            publishedDate: "2025-01-15",
            section: "Technology",
            author: "John Doe",
            type: "Article",
            title: "SwiftUI Best Practices",
            abstract: "Learn about modern SwiftUI development",
            media: nil
        )
        
        mockRepository.stubbedArticles = [mockArticle]
        mockRepository.shouldFail = false
        
        // When
        do {
            let articles = try await mockRepository.fetchArticles(pathType: .viewed, period: .week)
            
            // Then
            XCTAssertEqual(articles.count, 1)
            XCTAssertEqual(articles.first?.id, 123)
            XCTAssertEqual(articles.first?.title, "SwiftUI Best Practices")
        } catch {
            XCTFail("Expected success, but got error: \(error)")
        }
    }
    
    func testFetchArticlesNetworkError() async {
        // Given
        mockRepository.shouldFail = true
        mockRepository.errorToThrow = NetworkError.noData
        
        // When & Then
        do {
            _ = try await mockRepository.fetchArticles(pathType: .viewed, period: .week)
            XCTFail("Expected network error, but got success")
        } catch let error as NetworkError {
            XCTAssertEqual(error, NetworkError.noData)
        } catch {
            XCTFail("Expected NetworkError, but got \(error)")
        }
    }
    
    func testFetchArticlesEmptyResult() async {
        // Given
        mockRepository.stubbedArticles = []
        mockRepository.shouldFail = false
        
        // When
        do {
            let articles = try await mockRepository.fetchArticles(pathType: .shared, period: .day)
            
            // Then
            XCTAssertEqual(articles.count, 0)
        } catch {
            XCTFail("Expected success with empty array, but got error: \(error)")
        }
    }
}

// MARK: - Real Repository Tests (Testing actual NYTArticleRepository)
class NYTArticleRepositoryTests: XCTestCase {
    
    var repository: NYTArticleRepository!
    var mockNetworkService: MockNetworkService!
    
    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        repository = NYTArticleRepository(networkService: mockNetworkService)
    }
    
    override func tearDown() {
        repository = nil
        mockNetworkService = nil
        super.tearDown()
    }
    
    func testFetchArticlesSuccess() async {
        // Given
        let mockArticle = Article(
            url: "https://nytimes.com/article1",
            id: 123,
            source: "The New York Times",
            publishedDate: "2025-01-15",
            section: "Technology",
            author: "John Doe",
            type: "Article",
            title: "SwiftUI Best Practices",
            abstract: "Learn about modern SwiftUI development",
            media: nil
        )
        let mockResponse = NYTResponse(results: [mockArticle])
        
        do {
            let mockData = try JSONEncoder().encode(mockResponse)
            mockNetworkService.mockData = mockData
            mockNetworkService.shouldFail = false
            
            // When
            let articles = try await repository.fetchArticles(pathType: .viewed, period: .week)
            
            // Then
            XCTAssertEqual(articles.count, 1)
            XCTAssertEqual(articles.first?.id, 123)
            XCTAssertEqual(articles.first?.title, "SwiftUI Best Practices")
            
        } catch {
            XCTFail("Expected success, but got error: \(error)")
        }
    }
    
    func testFetchArticlesNetworkError() async {
        // Given
        mockNetworkService.shouldFail = true
        mockNetworkService.mockError = NetworkError.noData
        
        // When & Then
        do {
            _ = try await repository.fetchArticles(pathType: .viewed, period: .week)
            XCTFail("Expected network error, but got success")
        } catch let error as NetworkError {
            XCTAssertEqual(error, NetworkError.noData)
        } catch {
            XCTFail("Expected NetworkError, but got \(error)")
        }
    }
}
