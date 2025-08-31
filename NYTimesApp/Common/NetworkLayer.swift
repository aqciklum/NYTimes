//
//  NetworkLayer.swift
//  NYTimesApp
//
//  Created by Abdul Qadar on 18/03/2025.
//

import Foundation

// Define possible network errors
enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingFailed
    case serverError(statusCode: Int)
    case unknown(Error)
}

// MARK: - Network Service (Generic HTTP Methods)
enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
}

protocol NetworkServiceProtocol {
    func request<T: Decodable>(url: URL, method: HTTPMethod, body: Data?) async throws -> T
}

// MARK: Generic Network Layer
class NetworkService: NetworkServiceProtocol {
    
    func request<T: Decodable>(url: URL, method: HTTPMethod, body: Data?) async throws -> T {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if body != nil {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = body
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.serverError(statusCode: 0)
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        }
        
        guard !data.isEmpty else {
            throw NetworkError.noData
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            // Log the actual error for debugging
            print("Decoding failed: \(error)")
            throw NetworkError.decodingFailed
        }
    }
}

extension NetworkError: Equatable {
    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL):
            return true
        case (.noData, .noData):
            return true
        case (.decodingFailed, .decodingFailed):
            return true
        case (.serverError(let lhsStatusCode), .serverError(let rhsStatusCode)):
            return lhsStatusCode == rhsStatusCode
        case (.unknown(let lhsError), .unknown(let rhsError)):
            return (lhsError.localizedDescription == rhsError.localizedDescription)
        default:
            return false
        }
    }
}
