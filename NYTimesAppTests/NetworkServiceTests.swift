//
//  NetworkServiceTests.swift
//  NYTimesApp
//
//  Created by Abdul Qadar on 30/8/2025.
//

import XCTest
@testable import NYTimesApp

final class NetworkServiceTests: XCTestCase {
    
    var mockNetworkService: MockNetworkService!
    
    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
    }
    
    override func tearDown() {
        mockNetworkService = nil
        super.tearDown()
    }
    
    func testRequestSuccess() async {
        // Given
        let mockArticle = Article(id: 1, title: "Test Article")
        let mockResponse = NYTResponse(results: [mockArticle])
        let mockData = try! JSONEncoder().encode(mockResponse)
        
        mockNetworkService.mockData = mockData
        mockNetworkService.shouldFail = false
        
        let url = URL(string: "https://example.com")!
        
        // When
        do {
            let response: NYTResponse = try await mockNetworkService.request(
                url: url,
                method: .GET,
                body: nil
            )
            
            // Then
            XCTAssertEqual(response.results.count, 1)
            XCTAssertEqual(response.results.first?.id, 1)
            XCTAssertEqual(response.results.first?.title, "Test Article")
        } catch {
            XCTFail("Expected success, but got error: \(error)")
        }
    }
    
    func testRequestNoDataError() async {
        // Given
        mockNetworkService.shouldFail = true
        mockNetworkService.mockError = NetworkError.noData
        
        let url = URL(string: "https://example.com")!
        
        // When & Then
        do {
            let _: NYTResponse = try await mockNetworkService.request(
                url: url,
                method: .GET,
                body: nil
            )
            XCTFail("Expected failure, but got success")
        } catch let error as NetworkError {
            XCTAssertEqual(error, NetworkError.noData)
        } catch {
            XCTFail("Expected NetworkError.noData, but got \(error)")
        }
    }
    
    func testRequestDecodingError() async {
        // Given - Invalid JSON data
        let invalidData = "invalid json".data(using: .utf8)!
        mockNetworkService.mockData = invalidData
        mockNetworkService.shouldFail = false
        
        let url = URL(string: "https://example.com")!
        
        // When & Then
        do {
            let _: NYTResponse = try await mockNetworkService.request(
                url: url,
                method: .GET,
                body: nil
            )
            XCTFail("Expected decoding failure, but got success")
        } catch let error as NetworkError {
            XCTAssertEqual(error, NetworkError.decodingFailed)
        } catch {
            XCTFail("Expected NetworkError.decodingFailed, but got \(error)")
        }
    }
}
