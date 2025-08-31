//
//  NYTimesAPI.swift
//  NYTimesApp
//
//  Created by AQCiklum on 31/08/2025.
//
import Foundation

// MARK: - API Constants
struct NYTimesAPI {
    static let baseURL = "https://api.nytimes.com/svc/mostpopular/v2/"
    
    static var apiKey: String {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "Api_key") as? String else {
            fatalError("NYTimes API key not found in Info.plist")
        }
        return key
    }
    
    // Here we can specilized end point for each api call
    static func mostPopularURL(pathType: PathType, period: Period) -> URL? {
        let urlString = "\(baseURL)\(pathType.rawValue)/\(period.rawValue).json?api-key=\(apiKey)"
        return URL(string: urlString)
    }
}
