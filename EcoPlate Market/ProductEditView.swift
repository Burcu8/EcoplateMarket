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

    @Environment(\.presentationMode) var presentationMode
    @State private var isLoading = false
    @State private var showSuccessAlert = false

    @FocusState private var focusedField: Field?

    enum Field: Hashable {
        case name, description, price, discountedPrice, grammage, category
    }

    // Kategori seçenekleri
    let categoryOptions = ["Bakliyat", "Et Ürünleri", "Fırın", "İçecek", "Meyve & Sebze", "Temel Gıda", "Süt Ürünleri", "Yağ"]

    func saveProduct() {
        isLoading = true
        guard let marketid = Auth.auth().currentUser?.uid else {
            print("Kullanıcı oturumu yok!")
            isLoading = false
            return
        }

        guard let price = Double(price), price > 0 else {
            errorMessage = "Lütfen geçerli bir normal fiyat girin."
            isLoading = false
            return
        }

        guard let discounted_price = Double(discounted_price), discounted_price > 0 else {
            errorMessage = "Lütfen geçerli bir indirimli fiyat girin."
            isLoading = false
            return
        }

        if name.isEmpty || description.isEmpty || grammage.isEmpty || category.isEmpty {
            errorMessage = "Lütfen tüm alanları doldurduğunuzdan emin olun."
            isLoading = false
            return
        }

        guard let image = productImage,
              let imageData = image.jpegData(compressionQuality: 0.8) else {
            errorMessage = "Lütfen bir ürün görseli seçin."
            isLoading = false
            return
        }

        let db = Firestore.firestore()
        let marketRef = db.collection("markets").document(marketid).collection("products")
        let productRef = marketRef.document()
        let productId = productRef.documentID
        self.id = productId

        let storageRef = Storage.storage().reference()
        let imageRef = storageRef.child("products/\(productId)/main.jpg")

        imageRef.putData(imageData, metadata: nil) { metadata, error in
            isLoading = false
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

                productRef.setData([
                    "id": productId,
                    "name": name,
                    "description": description,
                    "discounted_price": discounted_price,
                    "price": price,
                    "grammage": grammage,
                    "expiry_date": expiry_date,
                    "image_url": productImage,
                    "category": category
                ]) { error in
                    if let error = error {
                        errorMessage = "Veri kaydedilemedi: \(error.localizedDescription)"
                    } else {
                        errorMessage = nil
                        showSuccessAlert = true
                    }
                }
            }
        }
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 15) {
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

                    VStack(spacing: 16) {
                        Group {
                            TextField("Ürün Adı (Zorunlu)", text: $name)
                                .focused($focusedField, equals: .name)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
                                .shadow(radius: 5)

                            TextField("Ürün Açıklaması (Zorunlu)", text: $description)
                                .focused($focusedField, equals: .description)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
                                .shadow(radius: 5)

                            HStack {
                                TextField("Normal Fiyat (Zorunlu)", text: $price)
                                    .keyboardType(.decimalPad)
                                    .focused($focusedField, equals: .price)
                                    .padding()
                                    .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
                                    .shadow(radius: 5)
                                    .frame(maxWidth: .infinity)

                                TextField("İndirimli Fiyat (Zorunlu)", text: $discounted_price)
                                    .keyboardType(.decimalPad)
                                    .focused($focusedField, equals: .discountedPrice)
                                    .padding()
                                    .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
                                    .shadow(radius: 5)
                                    .frame(maxWidth: .infinity)
                            }

                            // Picker ile kategori seçimi
                            Menu {
                                ForEach(categoryOptions, id: \.self) { option in
                                    Button(option) {
                                        category = option
                                    }
                                }
                            } label: {
                                categoryLabel
                            }.buttonStyle(PlainButtonStyle())
                            
                            TextField("Gramaj (g) (Zorunlu)", text: $grammage)
                                .keyboardType(.decimalPad)
                                .focused($focusedField, equals: .grammage)
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
                            .background(Color.primaryA) // Eğer Color.primaryA tanımlı değilse blue olarak ayarlandı
                            .cornerRadius(12)
                            .shadow(radius: 10)
                    }
                    .padding(.horizontal)
                }
                .padding(.top, 16)
            }
            .onTapGesture {
                focusedField = nil
            }
            .navigationBarTitle("Ürün Yükle", displayMode: .inline)
        }
        
        .alert("Başarılı", isPresented: $showSuccessAlert) {
            Button("Tamam") {
                presentationMode.wrappedValue.dismiss()
            }
        } message: {
            Text("Ürün başarıyla yüklendi.")
        }
    }
    // ✅ Menü için ayrı view
        var categoryLabel: some View {
            HStack {
                Text(category.isEmpty ? "Kategori Seçiniz (Zorunlu)" : category)
                    .foregroundColor(category.isEmpty ? .gray : .primary)
                Spacer()
                Image(systemName: "chevron.down")
                    .foregroundColor(.gray)
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
            .shadow(radius: 5)
        }
}



struct ProductEditView_Previews: PreviewProvider {
    static var previews: some View {
        ProductEditView()
    }
}
