//
//  ArticleViewModel.swift
//  NYTimesApp
//
//  Created by Abdul Qadar on 29/08/2025.

import SwiftUI
import Combine

@MainActor
class ArticleViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published private(set) var articles: [Article] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String?
    
    // Clean approach: Let Combine handle ALL reactive updates
    @Published var selectedPathType: PathType = .viewed
    @Published var selectedPeriod: Period = .week
    
    // MARK: - Private Properties
    private let repository: ArticleRepository
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init(repository: ArticleRepository) {
        self.repository = repository
        setupCombineBindings()
    }
    
    // MARK: - Combine Setup (Single Source of Truth)
    private func setupCombineBindings() {
        // This handles ALL filter changes - initial load AND updates
        Publishers.CombineLatest($selectedPathType, $selectedPeriod)
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] pathType, period in
                Task {
                    await self?.performLoadArticles(pathType: pathType, period: period)
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Public Methods
    func refreshArticles() {
        Task {
            await performLoadArticles(
                pathType: selectedPathType,
                period: selectedPeriod
            )
        }
    }
    
    // MARK: - Private Methods
    func performLoadArticles(pathType: PathType, period: Period) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedArticles = try await repository.fetchArticles(
                pathType: pathType,
                period: period
            )
            articles = fetchedArticles
        } catch let networkError as NetworkError {
            errorMessage = ErrorHandler.handleNetworkError(networkError)
        } catch {
            errorMessage = "An unexpected error occurred: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
}
