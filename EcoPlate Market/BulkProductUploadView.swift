//
//  BulkProductUploadView.swift
//  EcoPlate Market
//
//  Created by Burcu Kamilçelebi on 18.03.2025.
//
import SwiftUI

struct BulkProductUploadView: View {
    var body: some View {
        NavigationView { // NavigationView ekledik
            VStack(spacing: 20) {
                // Profil Alanı
                VStack {
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.gray)
                    
                    Text("Market İsmi")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("market@mail.com")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.top, 20)
                
                Divider()
                
                // Ürün Düzenleme Linki
                NavigationLink(destination: ProductEditView()) {
                    HStack {
                        Text("Ürün Düzenleme")
                            .font(.headline)
                            .foregroundStyle(.gray60)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray60)
                    }
                    .padding(.horizontal)
                }
                
                Divider()
                
                // Çoklu Fotoğraf Yükleme Alanı
                VStack(spacing: 15) {
                    ForEach(0..<3) { _ in
                        HStack(spacing: 15) {
                            ForEach(0..<3) { _ in
                                NavigationLink(destination: ProductEditView()) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(Color.gray.opacity(0.6), lineWidth: 2)
                                            .background(Color.white)
                                            .cornerRadius(15)
                                            .shadow(radius: 5)
                                            .frame(width: 115, height: 115)
                                        
                                        Image(systemName: "photo.fill")
                                            .resizable()
                                            .foregroundColor(.gray)
                                            .frame(width: 50, height: 50)
                                    }
                                }
                                .buttonStyle(PlainButtonStyle()) // Buton stilini düz yapmak için
                            }
                        }
                    }
                }
                .padding(.top, 20)

                
                Spacer()
            }
            .padding()
            
        }
        .navigationTitle("Bulk Product Yükleme")
    }
}

struct BulkProductUploadView_Previews: PreviewProvider {
    static var previews: some View {
        BulkProductUploadView()
    }
}

