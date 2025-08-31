//
//  MockArticleRepository.swift
//  NYTimesApp
//
//  Created by Abdul Qadar on 30/8/2025.
//

import XCTest
@testable import NYTimesApp

// MARK: - Simple Mock Repository (doesn't use network service)
class MockArticleRepository: ArticleRepository {
    var stubbedArticles: [Article] = []
    var shouldFail = false
    var errorToThrow: NetworkError = NetworkError.noData
    
    func fetchArticles(pathType: PathType, period: Period) async throws -> [Article] {
        if shouldFail {
            throw errorToThrow
        }
        return stubbedArticles
    }
}
