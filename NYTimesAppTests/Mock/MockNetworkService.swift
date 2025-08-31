//
//  MockNetworkService.swift
//  NYTimesApp
//
//  Created by Abdul Qadar on 30/8/2025.
//

import XCTest
@testable import NYTimesApp

class MockNetworkService: NetworkServiceProtocol {
    var shouldFail = false
    var mockData: Data?
    var mockError: NetworkError?
    var mockStatusCode = 200
    
    func request<T: Decodable>(url: URL, method: HTTPMethod, body: Data?) async throws -> T {
        if shouldFail {
            throw mockError ?? NetworkError.unknown(NSError(domain: "Test", code: 0))
        }
        
        guard (200...299).contains(mockStatusCode) else {
            throw NetworkError.serverError(statusCode: mockStatusCode)
        }
        
        guard let data = mockData else {
            throw NetworkError.noData
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingFailed
        }
    }
}
