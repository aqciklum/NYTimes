//
//  ErrorHandler.swift
//  NYTimesApp
//
//  Created by Abdul Qadar on 18/03/2025.
//

import Foundation

struct ErrorHandler {
    static func handleNetworkError(_ error: NetworkError) -> String {
        switch error {
        case .invalidURL:
            return "Invalid URL. Please try again later."
        case .noData:
            return "No data available. Please try again later."
        case .decodingFailed:
            return "Error processing the data. Please try again."
        case .serverError(let statusCode):
            return "Server error (Code: \(statusCode)). Please try again."
        case .unknown:
            return "An unknown error occurred. Please try again."
        }
    }
    
    // Optional: Log errors globally if needed
    static func logError(_ error: NetworkError) {
        // You can log to a service or store errors for debugging
        print("Logged Error: \(error)")
    }
}
