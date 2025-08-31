//
//  ArticleViewModelTests.swift
//  NYTimesApp
//
//  Created by Abdul Qadar on 30/8/2025.
//

import XCTest
@testable import NYTimesApp

class ArticleViewModelTests: XCTestCase {
    
    // A mock ArticleRepository to inject into the ViewModel
    class MockArticleRepository: ArticleRepository {
        var result: Result<[Article], Error> = .success([])
        
        func fetchArticles(pathType: PathType, period: Period) async throws -> [Article] {
            switch result {
            case .success(let articles):
                return articles
            case .failure(let error):
                throw error
            }
        }
    }

    func testLoadArticlesSuccess() async {
        // Setup
        let mockRepo = MockArticleRepository()
        let viewModel = await ArticleViewModel(repository: mockRepo)
        mockRepo.result = .success([Article(id: 1, title: "Test Article")])

        // Execute
        await viewModel.performLoadArticles(pathType: .viewed, period: .week)

        // Assert
        await MainActor.run {
            XCTAssertFalse(viewModel.isLoading)
            XCTAssertNil(viewModel.errorMessage)
            XCTAssertEqual(viewModel.articles.count, 1)
        }
    }

    func testLoadArticlesFailure() async {
        // Setup
        let mockRepo = MockArticleRepository()
        let viewModel = await ArticleViewModel(repository: mockRepo)
        mockRepo.result = .failure(NetworkError.serverError(statusCode: 500))

        // Execute
        await viewModel.performLoadArticles(pathType: .viewed, period: .week)

        // Assert
        await MainActor.run {
            XCTAssertFalse(viewModel.isLoading)
            XCTAssertNotNil(viewModel.errorMessage)
            XCTAssertEqual(viewModel.articles.count, 0)
        }
    }
}
