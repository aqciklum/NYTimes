//
//  NYTimesAppApp.swift
//  NYTimesApp
//
//  Created by Abdul Qadar on 29/08/2025.

import SwiftUI

@main
struct NYTimesAppApp: App {
    var body: some Scene {
        WindowGroup {
            let networkService = NetworkService() /// Create the network service
            let repository = NYTArticleRepository(networkService: networkService) /// Create the repository
            ArticleView(repository: repository) /// Pass the repository to the view
        }
    }
}
