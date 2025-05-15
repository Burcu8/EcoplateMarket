//
//  DynamicProductCardView.swift
//  EcoPlate Market
//
//  Created by Burcu Kamilçelebi on 11.04.2025.
//

import SwiftUI

struct DynamicProductCardView: View {
    @ObservedObject var product: DynamicProduct // Bu model Firestore'dan alınacak veriyi temsil ediyor
    

    var body: some View {
        VStack {
            // Ürün resmi
            AsyncImage(url: URL(string: product.image_url)) { image in
                image.resizable()
                     .scaledToFit()
                     .frame(height: 120)
                     .clipped()
                     .offset(y: -15)
            } placeholder: {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .frame(width: 150, height: 140)
                    
                    VStack(spacing: 8) {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                            .scaleEffect(1.2)
                        Text("Yükleniyor...")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .offset(y: -15)
            }

            Text(product.name)
                .font(.headline)
                .multilineTextAlignment(.center)
                .foregroundColor(.black)
                .padding(.top, -20)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            
            Text("\(product.grammage), fiyat")
                .font(.system(size: 17))
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("\(formattedDate(product.expiry_date))")
                .font(.system(size: 12))
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack {
                if product.discounted_price != product.price {
                    Text("₺\(String(format: "%.2f", product.price))")
                        .font(.system(size: 18))
                        .strikethrough()
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 1)
                        .offset(y: 15)
                }
                
                Text("₺\(String(format: "%.2f", product.discounted_price))")
                    .font(.system(size: 22))
                    .bold()
                    .foregroundColor(.primaryA)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .offset(y: 10)
            }
            
        }
        .frame(width: 160, height: 250)
        .padding(10)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
    }
    func formattedDate(_ date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            return formatter.string(from: date)
    }
}


struct DynamicProductCardView_Previews: PreviewProvider {
    static var previews: some View {
        DynamicProductCardView(product: DynamicProduct(
            id: "1",
            name: "Örnek Ürün",
            description: "Bu, örnek bir ürün açıklamasıdır.",
            price: 120,
            discounted_price: 100,
            grammage: "1",
            expiry_date: Date(),
            image_url: "https://via.placeholder.com/150",
            category: "Meyve"
        ))
    }
}
