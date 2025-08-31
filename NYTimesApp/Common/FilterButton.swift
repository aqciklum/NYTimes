//
//  FilterButton.swift
//  NYTimesApp
//
//  Created by AQCiklum on 29/08/2025.
//
import SwiftUI

// MARK: - Filter Button Component
struct FilterButton: View {
    let title: String
    let subtitle: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.blue)
                .frame(width: 20) // Fixed width for consistent alignment
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .lineLimit(1) // Prevent text overflow
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1) // Prevent text overflow
            }
            .frame(maxWidth: .infinity, alignment: .leading) // Text takes remaining space
            
            Image(systemName: "chevron.down")
                .font(.caption)
                .foregroundColor(.secondary)
                .frame(width: 12) // Fixed width for chevron
        }
        .padding(10)
//        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2)
        )
        .frame(height: 50) // Fixed height for consistent button size
    }
}
