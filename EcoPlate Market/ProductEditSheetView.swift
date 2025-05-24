//
//  ProductEditSheetView.swift
//  EcoPlate Market
//
//  Created by Burcu Kamilçelebi on 30.04.2025.
//

import SwiftUI
import PhotosUI
import FirebaseStorage
import FirebaseFirestore
import Firebase

import Foundation
import UIKit

struct Product2 {
    var id: String
    var name: String
    var description: String
    var normalPrice: Double
    var oldPrice: Double
    var weight: String
    var expirationDate: Date
    var image: UIImage?
    //var imageUrl: String?
    var category: String
    
    init(id: String, name: String, description: String, normalPrice: Double, oldPrice: Double, weight: String, expirationDate: Date, image: UIImage?, category: String) {
        self.id = id
        self.name = name
        self.description = description
        self.normalPrice = normalPrice
        self.oldPrice = oldPrice
        self.weight = weight
        self.expirationDate = expirationDate
        self.image = image
        self.category = category
    }
}


struct ProductEditSheetView: View {
    
    // Focus durumlarını tutmak için enum tanımlayalım
    enum Field: Hashable {
        case productName, productDescription, normalPrice, oldPrice, productCategory, productWeight
    }
    
    @FocusState private var focusedField: Field?   // FocusState tanımı
    
    @State private var productid: String = ""
    @State private var productName: String = ""
    @State private var productDescription: String = ""
    @State private var normalPrice: String = ""
    @State private var oldPrice: String = ""
    @State private var productWeight: String = ""
    @State private var expirationDate = Date()
    @State private var productImage: UIImage? = nil
    @State private var productCategory: String = ""
    @State private var showingImagePicker = false
    @State private var errorMessage: String?
    
    @Binding var products: [Product2?]
    @Binding var selectedBoxIndex: Int?
    
    @Environment(\.presentationMode) var presentationMode
    
    func saveProduct(existingProduct: Product2, productId: String, marketid: String) {
        let db = Firestore.firestore()
        let storage = Storage.storage()
        
        // ✅ Eğer kullanıcı yeni bir görsel seçtiyse:
        if let image = productImage, let imageData = image.jpegData(compressionQuality: 0.8) {
            // Yeni görseli Storage'a yükle
            let imageRef = storage.reference().child("products/\(productId)/main.jpg")
            
            imageRef.putData(imageData, metadata: nil) { metadata, error in
                if let error = error {
                    errorMessage = "Görsel yüklenirken hata: \(error.localizedDescription)"
                    return
                }
                
                imageRef.downloadURL { url, error in
                    if let error = error {
                        errorMessage = "Görsel URL'si alınırken hata: \(error.localizedDescription)"
                        return
                    }
                    
                    guard let imageUrl = url?.absoluteString else {
                        errorMessage = "Görsel URL'si alınamadı."
                        return
                    }
                    
                    // Görsel dahil tüm verileri güncelle
                    let updatedData: [String: Any] = [
                        "name": productName,
                        "description": productDescription,
                        "discounted_price": normalPrice,
                        "price": oldPrice,
                        "grammage": productWeight,
                        "expiry_date": expirationDate,
                        "category": productCategory,
                        "image_url": imageUrl
                    ]
                    
                    db.collection("markets").document(marketid)
                        .collection("products").document(productId)
                        .updateData(updatedData) { error in
                            if let error = error {
                                errorMessage = "Güncelleme hatası: \(error.localizedDescription)"
                            } else {
                                print("Ürün ve görsel güncellendi.")
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                }
            }
        }
        
        // ✅ Eğer görsel değiştirilmediyse:
        else {
            let updatedData: [String: Any] = [
                "id": productid,
                "name": productName,
                "description": productDescription,
                "discounted_price": normalPrice,
                "price": oldPrice,
                "grammage": productWeight,
                "expiry_date": expirationDate,
                "category": productCategory,
                "image_url": existingProduct.image // Mevcut URL
            ]
            
            db.collection("markets").document(marketid)
                .collection("products").document(productId)
                .updateData(updatedData) { error in
                    if let error = error {
                        errorMessage = "Güncelleme hatası: \(error.localizedDescription)"
                    } else {
                        print("Ürün bilgileri güncellendi (görsel aynı kaldı).")
                        presentationMode.wrappedValue.dismiss()
                    }
                }
        }
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 15) {
                    // Fotoğraf Seçim Alanı
                    Button(action: {
                        showingImagePicker.toggle()
                    }) {
                        ZStack {
                            if let productImage = productImage {
                                Image(uiImage: productImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 380, height: 260)
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.blue, lineWidth: 3)
                                    )
                                    .shadow(radius: 10)
                            } else {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(width: 380, height: 260)
                                    .overlay(
                                        Image(systemName: "photo.on.rectangle.angled")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 60, height: 60)
                                            .foregroundColor(.gray)
                                    )
                                    .shadow(radius: 8)
                            }
                        }
                    }
                    .sheet(isPresented: $showingImagePicker) {
                        ImagePicker(selectedImage: $productImage)
                    }
                    
                    // Ürün Bilgileri
                    VStack(spacing: 16) {
                        Group {
                            // Ürün Adı
                            TextField("Ürün Adı (Zorunlu)", text: $productName)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
                                .shadow(radius: 5)
                                .focused($focusedField, equals: .productName)
                            
                            // Ürün Açıklaması
                            TextField("Ürün Açıklaması (Zorunlu)", text: $productDescription)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
                                .shadow(radius: 5)
                                .focused($focusedField, equals: .productDescription)
                            
                            
                            HStack {
                                TextField("Normal Fiyat (Zorunlu)", text: $oldPrice)
                                    .keyboardType(.decimalPad)
                                    .padding()
                                    .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
                                    .shadow(radius: 5)
                                    .frame(maxWidth: .infinity)
                                    .focused($focusedField, equals: .oldPrice)
                                
                                TextField("İndirimli Fiyat (Zorunlu)", text: $normalPrice)
                                    .keyboardType(.decimalPad)
                                    .padding()
                                    .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
                                    .shadow(radius: 5)
                                    .frame(maxWidth: .infinity)
                                    .focused($focusedField, equals: .normalPrice)
                            }
                            TextField("Kategori (Zorunlu)", text: $productCategory)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
                                .shadow(radius: 5)
                                .focused($focusedField, equals: .productCategory)
                            
                           
                            TextField("Gramaj (g) (Zorunlu)", text: $productWeight)
                                .keyboardType(.decimalPad)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
                                .shadow(radius: 5)
                                .focused($focusedField, equals: .productWeight)
                        }
                        
                        
                        DatePicker("Son Kullanma Tarihi (Zorunlu)", selection: $expirationDate, displayedComponents: .date)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
                            .shadow(radius: 5)
                    }
                    .padding(.horizontal)
                    
                    // Hata Mesajı
                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()
                    }
                    
                    Button(action: {
                        // Double'a dönüşüm yapmadan önce geçerlilik kontrolü yapıyoruz
                        guard let normalPrice = Double(normalPrice), normalPrice > 0 else {
                            errorMessage = "Lütfen geçerli bir normal fiyat girin."
                            return
                        }

                        guard let oldPrice = Double(oldPrice), oldPrice > 0 else {
                            errorMessage = "Lütfen geçerli bir indirimli fiyat girin."
                            return
                        }
                        
                        guard let index = selectedBoxIndex else { return }

                        let newProduct = Product2(
                            id: productid,
                            name: productName,
                            description: productDescription,
                            normalPrice: normalPrice,
                            oldPrice: oldPrice,
                            weight: productWeight,
                            expirationDate: expirationDate,
                            image: productImage,
                            category: productCategory
                        )

                        products[index] = newProduct
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Kaydet")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: 300)
                            .padding()
                            .background(.primaryA)
                            .cornerRadius(12)
                            .shadow(radius: 10)
                    }
                }
                .padding(.top, 16)
            }
            .navigationBarTitle("Ürün Düzenleme", displayMode: .inline)
            // Boş alana dokunulduğunda focus'u kaldır ve klavyeyi kapat
              .onTapGesture {
                  focusedField = nil
              }
        }
    }
}

struct ProductEditSheetView_Previews: PreviewProvider {
    @State static var sampleProducts: [Product2?] = []
    @State static var sampleSelectedBoxIndex: Int? = 0

    static var previews: some View {
        ProductEditSheetView(
            products: $sampleProducts,
            selectedBoxIndex: $sampleSelectedBoxIndex
        )
    }
}

