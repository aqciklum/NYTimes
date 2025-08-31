//
//  ArticleView.swift
//  NYTimesApp
//
//  Created by Abdul Qadar on 29/08/2025.

import SwiftUI

// MARK: - Main Article View
struct ArticleView: View {
    
    @StateObject private var viewModel: ArticleViewModel
    
    init(repository: ArticleRepository) {
        _viewModel = StateObject(wrappedValue: ArticleViewModel(repository: repository))
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Filter Section
                filterSection
                
                // Content Section
                contentSection
            }
            .navigationTitle("NY Times")
            .navigationBarTitleDisplayMode(.automatic)
            .refreshable {
                viewModel.refreshArticles()
            }
        }
    }
}

// MARK: - ViewBuilder Extensions
extension ArticleView {
    
    @ViewBuilder
    private var filterSection: some View {
        HStack(spacing: 20) { // Fixed spacing between buttons
            // Path Type Filter
            Menu {
                ForEach(PathType.allCases) { pathType in
                    Button {
                        viewModel.selectedPathType = pathType
                    } label: {
                        Label(
                            pathType.title(),
                            systemImage: viewModel.selectedPathType == pathType ? "checkmark.circle.fill" : "circle"
                        )
                    }
                }
            } label: {
                FilterButton(
                    title: viewModel.selectedPathType.title(),
                    subtitle: "Article Type",
                    icon: "doc.text.fill"
                )
                .frame(maxWidth: .infinity) // Makes button expand to fill available space
            }
            
            // Period Filter
            Menu {
                ForEach(Period.allCases) { period in
                    Button {
                        viewModel.selectedPeriod = period
                    } label: {
                        Label(
                            period.title(),
                            systemImage: viewModel.selectedPeriod == period ? "checkmark.circle.fill" : "circle"
                        )
                    }
                }
            } label: {
                FilterButton(
                    title: viewModel.selectedPeriod.title(),
                    subtitle: "Time Period",
                    icon: "calendar.circle.fill"
                )
                .frame(maxWidth: .infinity) // Makes button expand to fill available space
            }
        }
        .padding(20) // Consistent horizontal padding
        .background(Color(.systemGray6))
    }
    
    @ViewBuilder
    private var contentSection: some View {
        if viewModel.isLoading {
            loadingView
        } else if !viewModel.articles.isEmpty {
            articlesList
        } else if let errorMessage = viewModel.errorMessage {
            errorView(errorMessage)
        } else {
            emptyStateView
        }
    }
    
    @ViewBuilder
    private var loadingView: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.2)
            Text("Loading articles...")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @ViewBuilder
    private var articlesList: some View {
        List(viewModel.articles) { article in
            NavigationLink(destination: ArticleDetailView(article: article)) {
                ArticleRow(article: article)
            }
            .listRowSeparator(.automatic)
//            .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
            .alignmentGuide(.listRowSeparatorLeading) { _ in
                return 0  // Separator starts from leading edge (16pt from screen due to listRowInsets)
            }
            .alignmentGuide(.listRowSeparatorTrailing) { dimensions in
                return dimensions.width  // Separator ends 0 from trailing edge
            }
        }
        .listStyle(.plain)
    }
    
    @ViewBuilder
    private func errorView(_ message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 48))
                .foregroundColor(.orange)
            
            Text("Oops! Something went wrong")
                .font(.headline)
                .multilineTextAlignment(.center)
            
            Text(message)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button("Try Again") {
                viewModel.refreshArticles()
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
    
    @ViewBuilder
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "newspaper")
                .font(.system(size: 48))
                .foregroundColor(.gray)
            
            Text("No Articles Found")
                .font(.headline)
            
            Text("Try adjusting your filters or check back later")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}
