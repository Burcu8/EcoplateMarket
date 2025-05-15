//
//  CategorySelectorView.swift
//  EcoPlate Market
//
//  Created by Burcu Kamilçelebi on 11.04.2025.
//

import SwiftUI

struct CategorySelectorView: View {
    @Binding var selectedCategory: String
    let categories = ["İçecek", "Meyve", "Sebze"]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(categories, id: \.self) { category in
                    NavigationLink(destination: ProductListView(selectedCategory: category)) {
                        Text(category)
                            .font(.headline)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .background(Color.green.opacity(0.4)) // Arka plan rengi sabitlendi
                            .foregroundColor(.primaryA) // Yazı rengi sabit
                            .cornerRadius(15)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    CategorySelectorView(selectedCategory: .constant("Meyve"))
}



