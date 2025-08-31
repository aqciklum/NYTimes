//
//  ArticleDetailView.swift
//  NYTimesApp
//
//  Created by AQCiklum on 30/08/2025.
//
import SwiftUI
import Combine

// MARK: - Main Article Detail View
struct ArticleDetailView: View {
    
    // MARK: - Properties
    let article: Article
    @StateObject private var viewModel: ArticleDetailViewModel
    @State private var showingShareSheet = false
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Initialization
    init(article: Article) {
        self.article = article
        _viewModel = StateObject(wrappedValue: ArticleDetailViewModel(article: article))
    }
    
    // MARK: - Body
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                Spacer(minLength: 8)
                heroImageSection
                contentSection
                actionButtonsSection
            }
        }
        .navigationTitle("Article")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                toolbarButtons
            }
        }
        .sheet(isPresented: $showingShareSheet) {
            ShareSheet(items: viewModel.shareArticle())
        }
    }
}

// MARK: - ViewBuilder Extensions
extension ArticleDetailView {
    
    @ViewBuilder
    private var heroImageSection: some View {
        GeometryReader { geometry in
            AsyncImage(url: URL(string: article.detailViewThumb ?? article.articlImageUrl ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
            } placeholder: {
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [Color.gray.opacity(0.2), Color.gray.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        VStack(spacing: 8) {
                            Image(systemName: "photo.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.gray.opacity(0.5))
                            Text("No Image Available")
                                .font(.caption)
                                .foregroundColor(.gray.opacity(0.7))
                        }
                    )
            }
        }
        .frame(height: 250)
        .background(Color.gray.opacity(0.1))
    }
    
    @ViewBuilder
    private var contentSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Article Title
            titleSection
            
            // Article Metadata
            metadataSection
            
            // Article Abstract
            abstractSection
        }
        .padding(20)
    }
    
    @ViewBuilder
    private var titleSection: some View {
        Text(article.title ?? "Untitled Article")
            .font(.headline)
            .fontWeight(.bold)
            .lineLimit(nil)
            .multilineTextAlignment(.leading)
    }
    
    @ViewBuilder
    private var metadataSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            if let author = article.author, !author.isEmpty {
                HStack(spacing: 10) {
                    Image(systemName: "person.circle.fill")
                        .foregroundColor(.blue)
                        .font(.title3)
                    
                    Text(author.hasPrefix("By ") ? author : "By \(author)")
                        .font(.subheadline)
                        .foregroundColor(.primary)
                }
            }
            
            if let publishedDate = article.publishedDate, !publishedDate.isEmpty {
                HStack(spacing: 10) {
                    Image(systemName: "calendar.circle.fill")
                        .foregroundColor(.green)
                        .font(.title3)
                    
                    Text("Published \(formatDate(publishedDate))")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
    
    @ViewBuilder
    private var abstractSection: some View {
        if let abstract = article.abstract, !abstract.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                // Header row: Summary (leading) + Section (trailing)
                HStack {
                    // Leading Summary
                    HStack {
                        Image(systemName: "text.alignleft")
                            .foregroundColor(.purple)
                            .font(.title3)
                        
                        Text("Summary")
                            .font(.headline)
                            .foregroundColor(.primary)
                    }
                    
                    Spacer() // pushes section to trailing
                    
                    // Trailing Section (if exists)
                    if let section = article.section, !section.isEmpty {
                        HStack(spacing: 10) {
                            Image(systemName: "folder.circle.fill")
                                .foregroundColor(.orange)
                                .font(.title3)
                            
                            Text(section)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 4)
                                .background(Color.orange.opacity(0.1))
                                .clipShape(Capsule())
                        }
                    }
                }
                
                // Abstract body text
                Text(abstract)
                    .font(.body)
                    .lineSpacing(4)
                    .foregroundColor(.primary)
                    .padding(.leading, 4)
            }
        }
    }
    
    @ViewBuilder
    private var actionButtonsSection: some View {
        VStack(spacing: 16) {
            // Primary Action - Read Full Article
            Button(action: viewModel.openFullArticle) {
                HStack(spacing: 12) {
                    Image(systemName: "safari.fill")
                        .font(.title3)
                    
                    Text("Read Full Article")
                        .font(.headline)
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(
                    LinearGradient(
                        colors: [Color.blue, Color.blue.opacity(0.8)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
            }
            
            // Secondary Actions Row
            HStack(spacing: 16) {
                // Bookmark Button
                Button(action: viewModel.toggleBookmark) {
                    HStack(spacing: 8) {
                        Image(systemName: viewModel.isBookmarked ? "bookmark.fill" : "bookmark")
                            .font(.title3)
                        
                        Text(viewModel.isBookmarked ? "Bookmarked" : "Bookmark")
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(viewModel.isBookmarked ? Color.yellow.opacity(0.2) : Color.gray.opacity(0.1))
                    .foregroundColor(viewModel.isBookmarked ? .orange : .primary)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                
                // Share Button
                Button(action: { showingShareSheet = true }) {
                    HStack(spacing: 8) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.title3)
                        
                        Text("Share")
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.gray.opacity(0.1))
                    .foregroundColor(.primary)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
    }
    
    @ViewBuilder
    private var toolbarButtons: some View {
        HStack(spacing: 15) {
            Button(action: viewModel.toggleBookmark) {
                Image(systemName: viewModel.isBookmarked ? "bookmark.fill" : "bookmark")
                    .foregroundColor(viewModel.isBookmarked ? .yellow : .primary)
            }
            
            Button(action: { showingShareSheet = true }) {
                Image(systemName: "square.and.arrow.up")
                    .foregroundColor(.primary)
            }
        }
    }
    
    // MARK: - Helper Functions
    private func formatDate(_ dateString: String) -> String {
        // Simple date formatting - We can further enhance this
        return dateString
    }
}

// MARK: - Share Sheet
struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
