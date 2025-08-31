//
//  NYTArticleRepository.swift
//  NYTimesApp
//
//  Created by Abdul Qadar on 29/08/2025.

import Foundation

// MARK: - Article Repository Protocols
protocol ArticleRepository {
    func fetchArticles(pathType: PathType, period: Period) async throws -> [Article]
}

// MARK: - Article Repository
class NYTArticleRepository: ArticleRepository {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func fetchArticles(pathType: PathType, period: Period) async throws -> [Article] {
        guard let url = NYTimesAPI.mostPopularURL(pathType: pathType, period: period) else {
            throw NetworkError.invalidURL
        }
        
        let response: NYTResponse = try await networkService.request(
            url: url,
            method: .GET,
            body: nil
        )
        return response.results
    }
}
