//
//  ArticleRow.swift
//  NYTimesApp
//
//  Created by Abdul Qadar on 29/08/2025.

import SwiftUI

// MARK: - Article Row Component
struct ArticleRow: View {
    let article: Article
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            /// Using AsyncImage (iOS 15+)
            AsyncImage(url: URL(string: article.articlImageUrl ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.2))
                    .overlay(
                        Image(systemName: "photo")
                            .font(.title2)
                            .foregroundColor(.gray.opacity(0.5))
                    )
            }
            .frame(width: 100, height: 120)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            // Article Info
            VStack(alignment: .leading, spacing: 6) {
                Text(article.title ?? "Untitled Article")
                    .font(.headline)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                Text(article.author ?? "Unknown Author")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                
                Text(article.publishedDate ?? "No Date")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 6)
    }
}
