//
//  ArticleDetailViewModel.swift
//  NYTimesApp
//
//  Created by AQCiklum on 30/08/2025.
//
import SwiftUI
import Combine

// MARK: - Article Detail ViewModel (Optional but adds sophistication)
@MainActor
class ArticleDetailViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published private(set) var isBookmarked: Bool = false
    @Published private(set) var isSharing: Bool = false
    
    // MARK: - Private Properties
    private let article: Article
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init(article: Article) {
        self.article = article
        loadBookmarkStatus()
    }
    
    // MARK: - Public Methods
    func toggleBookmark() {
        isBookmarked.toggle()
        saveBookmarkStatus()
    }
    
    func shareArticle() -> [Any] {
        var items: [Any] = []
        
        if let title = article.title {
            items.append(title)
        }
        if let urlString = article.url, let url = URL(string: urlString) {
            items.append(url)
        }
        
        return items
    }
    
    func openFullArticle() {
        guard let urlString = article.url,
              let url = URL(string: urlString) else { return }
        
        UIApplication.shared.open(url)
    }
    
    // MARK: - Private Methods
    private func loadBookmarkStatus() {
        // Simulate loading bookmark status from UserDefaults or Core Data
        if let articleId = article.id {
            isBookmarked = UserDefaults.standard.bool(forKey: "bookmark_\(articleId)")
        }
    }
    
    private func saveBookmarkStatus() {
        if let articleId = article.id {
            UserDefaults.standard.set(isBookmarked, forKey: "bookmark_\(articleId)")
        }
    }
}
