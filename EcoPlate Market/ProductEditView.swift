//
//  ProductEditView.swift
//  EcoPlate Market
//
//  Created by Burcu Kamilçelebi on 19.03.2025.
//

import SwiftUI
import PhotosUI

struct ProductEditView: View {

    @State private var productImage: UIImage? = nil
    @State private var showingImagePicker = false
    @State private var productName: String = ""
    @State private var productPrice: String = ""
    @State private var productDescription: String = ""
    
    
    var body: some View {
        VStack {
            // Üst Kısım: Fotoğraf Seçim Alanı
            VStack {
                Button(action: {
                    showingImagePicker.toggle()
                }) {
                    if let productImage = productImage {
                        Image(uiImage: productImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 140, height: 140)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.gray, lineWidth: 4))
                            .shadow(radius: 10)
                    } else {
                        ZStack {
                            // Kare şekli
                            Rectangle()
                                .fill(Color.gray.opacity(0.1)) // Daha yumuşak bir opaklık
                                .frame(width: 390, height: 350)
                                .cornerRadius(15) // Köşeleri yuvarlatıyoruz
                                .shadow(radius: 8) // Yumuşak gölge efekti
                            
                            // Fotoğraf simgesi
                            Image(systemName: "photo.fill") // Fotoğraf simgesi
                                .resizable()
                                .foregroundColor(.white) // Simgeyi beyaz yapalım
                                .font(.system(size: 40, weight: .bold)) // Simgeyi büyütüp kalınlaştırdık
                                .frame(width: 140, height: 140)
                                .shadow(radius: 5) // Simgeye hafif bir gölge efekti
                        }
                    }
                }
                .sheet(isPresented: $showingImagePicker) {
                    ImagePicker(selectedImage: $productImage)
                }
            }
            .padding(.top, 1)

            // Burada başka içerikler eklenebilir.
            // Ürün Bilgileri Formu
            
            Spacer()
            // Kaydet Butonu
            Button(action: {
                print("Ürün Kaydedildi: \(productName), \(productPrice), \(productDescription)")
            }) {
                Text("Kaydet")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
        .padding()
        .navigationTitle("Ürün Düzenleme")
    }
}

struct ProductEditView_Previews: PreviewProvider {
    static var previews: some View {
        ProductEditView()
    }
}



