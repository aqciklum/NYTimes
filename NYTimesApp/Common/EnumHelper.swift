//
//  EnumHelper.swift
//  NYTimesApp
//
//  Created by Abdul Qadar on 29/08/2025.

import Foundation

enum PathType: String, CaseIterable, Identifiable {
    var id: String {
        return self.rawValue
    }
    case viewed
    case shared

    func title() -> String {
        switch self {
        case .viewed:
            return "Most Viewed"
        case .shared:
            return "Most Shared"
        }
    }
}

enum Period: String, CaseIterable, Identifiable {
    var id: String {
        return self.rawValue
    }

    case day = "1"
    case week = "7"
    case month = "30"

    func title() -> String{
        switch self {
        case .day:
            return "Today"
        case .week:
            return "This Week"
        case .month:
            return "This Month"
        }
    }
}
