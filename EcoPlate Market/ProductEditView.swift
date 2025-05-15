//
//  ProductEditView.swift
//  EcoPlate Market
//
//  Created by Burcu Kamilçelebi on 19.03.2025.
//

import SwiftUI
import PhotosUI
import FirebaseStorage
import FirebaseFirestore
import Firebase
import FirebaseAuth

struct ProductEditView: View {
    @State private var id = ""
    @State private var name = ""
        @State private var description = ""
        @State private var price = ""
        @State private var discounted_price = ""
        @State private var grammage = ""
        @State private var category = ""
        @State private var expiry_date = Date()
        @State private var productImage: UIImage? = nil
        @State private var showingImagePicker = false
        @State private var errorMessage: String?

    @State private var navigateToHome = false
    
    @Environment(\.presentationMode) var presentationMode
    @State private var isLoading = false

    func saveProduct() {
        isLoading = true
        guard let marketid = Auth.auth().currentUser?.uid else {
            print("Kullanıcı oturumu yok!")
            return
        }

        guard let price = Double(price), price > 0 else {
            errorMessage = "Lütfen geçerli bir normal fiyat girin."
            return
        }

        guard let discounted_price = Double(discounted_price), discounted_price > 0 else {
            errorMessage = "Lütfen geçerli bir indirimli fiyat girin."
            return
        }

        if name.isEmpty || description.isEmpty || grammage.isEmpty {
            errorMessage = "Lütfen tüm alanları doldurduğunuzdan emin olun."
            return
        }

        guard let image = productImage,
              let imageData = image.jpegData(compressionQuality: 0.8) else {
            errorMessage = "Lütfen bir ürün görseli seçin."
            return
        }

        let db = Firestore.firestore()

        // Firestore referansı oluşturuluyor, ürünlerin kaydedileceği marketId koleksiyonu
        let marketRef = db.collection("markets").document(marketid).collection("products")

        // Yeni bir ürün için ürün ID'si oluşturuluyor
        let productRef = marketRef.document()  // Firebase otomatik olarak bir ID oluşturur
        let productId = productRef.documentID  // Firestore'da oluşturulan ürün ID'sini alıyoruz

        // ID'yi UI'da gösterilecek id değişkenine atıyoruz
        self.id = productId

        let storageRef = Storage.storage().reference()
        let imageRef = storageRef.child("products/\(productId)/main.jpg")  // Ürün fotoğrafı için yol

        isLoading = true // Yükleniyor göstergesini açıyoruz

        imageRef.putData(imageData, metadata: nil) { metadata, error in
            isLoading = false // Yükleniyor göstergesini kapatıyoruz
            if let error = error {
                errorMessage = "Fotoğraf yüklenemedi: \(error.localizedDescription)"
                return
            }

            imageRef.downloadURL { url, error in
                if let error = error {
                    errorMessage = "Fotoğraf URL alınamadı: \(error.localizedDescription)"
                    return
                }

                guard let productImage = url?.absoluteString else {
                    errorMessage = "Geçersiz fotoğraf URL’si."
                    return
                }

                // Ürün verisini Firestore'a kaydetme
                productRef.setData([
                    "id": productId,  // Firestore'da oluşturulan ID'yi kaydediyoruz
                    "name": name,
                    "description": description,
                    "discounted_price": discounted_price,
                    "price": price,
                    "grammage": grammage,
                    "expiry_date": expiry_date, // Expiry date burada doğru formatta olmalı
                    "image_url": productImage,
                    "category": category
                ]) { error in
                    if let error = error {
                        errorMessage = "Veri kaydedilemedi: \(error.localizedDescription)"
                    } else {
                        errorMessage = nil
                        presentationMode.wrappedValue.dismiss()  // Sayfayı kapatıyoruz
                        print("Ürün başarıyla kaydedildi.")
                    }
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
                                    .scaledToFit() // scaledToFill yerine
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
                            TextField("Ürün Adı (Zorunlu)", text: $name)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
                                .shadow(radius: 5)
                            
                            // Ürün Açıklaması
                            TextField("Ürün Açıklaması (Zorunlu)", text: $description)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
                                .shadow(radius: 5)
                            
                            
                            HStack {
                                TextField("Normal Fiyat (Zorunlu)", text: $price)
                                    .keyboardType(.decimalPad)
                                    .padding()
                                    .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
                                    .shadow(radius: 5)
                                    .frame(maxWidth: .infinity)
                                
                                TextField("İndirimli Fiyat (Zorunlu)", text: $discounted_price)
                                    .keyboardType(.decimalPad)
                                    .padding()
                                    .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
                                    .shadow(radius: 5)
                                    .frame(maxWidth: .infinity)
                            }
                            
                            TextField("Kategori (Zorunlu)", text: $category)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
                                .shadow(radius: 5)
                            
                           
                            TextField("Gramaj (g) (Zorunlu)", text: $grammage)
                                .keyboardType(.decimalPad)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
                                .shadow(radius: 5)
                        }
                        
                        
                        DatePicker("Son Kullanma Tarihi (Zorunlu)", selection: $expiry_date, displayedComponents: .date)
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
                        saveProduct()
                    }) {
                        Text("Ürünü Yükle")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.primaryA)
                            .cornerRadius(12)
                            .shadow(radius: 10)
                    }
                    .padding(.horizontal)
                }
                .padding(.top, 16)
            }
            .navigationBarTitle("Ürün Yükle", displayMode: .inline)
        }
    }
}

struct ProductEditView_Previews: PreviewProvider {
    static var previews: some View {
        ProductEditView()
    }
}




