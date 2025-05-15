//
//  EditProductView.swift
//  EcoPlate Market
//
//  Created by Burcu Kamilçelebi on 1.05.2025.
//

import SwiftUI
import FirebaseFirestore
import PhotosUI
import FirebaseAuth
import FirebaseStorage

struct EditProductView: View {
    @Environment(\.presentationMode) var presentationMode
    var product: DynamicProduct
    @State private var isUpdated = false


    @State private var name: String
    @State private var description: String
    @State private var discounted_price: String
    @State private var price: String
    @State private var grammage: String
    @State private var expiry_date: Date
    @State private var image_url: String
    @State private var category: String
    @State private var selectedImage: UIImage?

    @State private var showImagePicker = false

    init(product: DynamicProduct) {
        self.product = product
        
        _name = State(initialValue: product.name)
        _description = State(initialValue: product.description)
        _discounted_price = State(initialValue: String(product.discounted_price))
        _price = State(initialValue:String(product.price))
        _grammage = State(initialValue: product.grammage)
        _expiry_date = State(initialValue: product.expiry_date)
        _category = State(initialValue: product.category)
        _image_url = State(initialValue: product.image_url)

        //let formatter = DateFormatter()
        //formatter.dateFormat = "yyyy-MM-dd"
        //let date = formatter.date(from: product.expirationDate) ?? Date()
        //_expirationDate = State(initialValue: date)
    }
    // ✅ RESMİ FIREBASE STORAGE’A YÜKLE
    func uploadImageToStorage(image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(NSError(domain: "imageError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Resim verisine dönüştürülemedi."])))
            return
        }

        let fileName = UUID().uuidString + ".jpg"
        let ref = Storage.storage().reference().child("product_images/\(fileName)")

        ref.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            ref.downloadURL { url, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                if let downloadURL = url?.absoluteString {
                    completion(.success(downloadURL))
                } else {
                    completion(.failure(NSError(domain: "downloadURLError", code: -2, userInfo: [NSLocalizedDescriptionKey: "Download URL alınamadı."])))
                }
            }
        }
    }

    func updateProduct() {
        guard let marketId = Auth.auth().currentUser?.uid else {
            print("Kullanıcı oturumu yok!")
            return
        }

        guard let productId = product.id else {
            print("Ürün ID’si yok!")
            return
        }

        guard let priceValue = Double(price), let discountedPriceValue = Double(discounted_price) else {
            print("Fiyatlar geçerli değil.")
            return
        }

        let db = Firestore.firestore()
        let productRef = db.collection("markets").document(marketId).collection("products").document(productId)

        // Eğer yeni resim seçildiyse önce onu yükle
        if let selectedImage = selectedImage {
            uploadImageToStorage(image: selectedImage) { result in
                switch result {
                case .success(let downloadURL):
                    saveUpdatedData(to: productRef, imageUrl: downloadURL, priceValue: priceValue, discountedPriceValue: discountedPriceValue)
                case .failure(let error):
                    print("Fotoğraf yüklenemedi: \(error.localizedDescription)")
                    // Kullanıcıya yükleme hatası bildirim mesajı gösterilebilir
                }
            }
        } else {
            // Yeni resim yoksa, mevcut image_url’yi kullan
            saveUpdatedData(to: productRef, imageUrl: image_url, priceValue: priceValue, discountedPriceValue: discountedPriceValue)
        }
    }

    func saveUpdatedData(to ref: DocumentReference, imageUrl: String, priceValue: Double, discountedPriceValue: Double) {
        let updatedData: [String: Any] = [
            "name": name,
            "description": description,
            "discounted_price": discountedPriceValue,
            "price": priceValue,
            "grammage": grammage,
            "expiry_date": expiry_date,
            "image_url": imageUrl,
            "category": category,
            "last_updated": FieldValue.serverTimestamp() // Güncelleme zamanını kaydet
        ]

        ref.updateData(updatedData) { error in
            if let error = error {
                print("Güncelleme hatası: \(error.localizedDescription)")
                // Kullanıcıya hata mesajı gösterebiliriz
            } else {
                print("Ürün başarıyla güncellendi.")
                isUpdated = true
                // Kullanıcıya başarı mesajı gösterilebilir
                presentationMode.wrappedValue.dismiss()
            }
        }
    }



    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 15) {
                    // Fotoğraf Seçim Alanı
                    Button(action: {
                        showImagePicker.toggle()
                    }) {
                        ZStack {
                            if let image = selectedImage {
                                                        Image(uiImage: image)
                                                                .resizable()
                                                        .scaledToFill()
                                                                .frame(width: 380, height: 260)
                                                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                                                .overlay(
                                                                    RoundedRectangle(cornerRadius: 20)
                                                                        .stroke(Color.blue, lineWidth: 3)
                                                                )
                                                                .shadow(radius: 10)
                                                        } else if !image_url.isEmpty {
                                                            AsyncImage(url: URL(string: image_url)) { image in
                                                                image.resizable()
                                                                     .scaledToFill()
                                                                     .frame(width: 380, height: 260)
                                                                     .clipShape(RoundedRectangle(cornerRadius: 20))
                                                                     .overlay(
                                                                         RoundedRectangle(cornerRadius: 20)
                                                                             .stroke(Color.blue, lineWidth: 3)
                                                                     )
                                                                     .shadow(radius: 10)
                                                            } placeholder: {
                                                                ProgressView()
                                                                    .frame(width: 380, height: 260)
                                                            }
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
                    .sheet(isPresented: $showImagePicker) {
                        ImagePicker(selectedImage: $selectedImage)
                    }

                    // FORM
                    VStack(spacing: 16) {
                        TextField("Ürün Adı", text: $name)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
                            .shadow(radius: 5)

                        TextField("Ürün Açıklaması", text: $description)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
                            .shadow(radius: 5)

                        HStack {
                            TextField("Normal Fiyat", text: $price)
                                .keyboardType(.decimalPad)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
                                .shadow(radius: 5)
                                .frame(maxWidth: .infinity)

                            TextField("İndirimli Fiyat", text: $discounted_price)
                                .keyboardType(.decimalPad)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
                                .shadow(radius: 5)
                                .frame(maxWidth: .infinity)
                        }
                        
                        TextField("Kategori", text: $category)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
                            .shadow(radius: 5)

                        TextField("Gramaj (g)", text: $grammage)
                            .keyboardType(.decimalPad)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
                            .shadow(radius: 5)

                        DatePicker("Son Kullanma Tarihi", selection: $expiry_date, displayedComponents: .date)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
                            .shadow(radius: 5)
                    }
                    .padding(.horizontal)

                    Button(action: {
                        updateProduct()
                        isUpdated = true
                    }) {
                        Text("Ürünü Güncelle")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.primaryA)
                            .cornerRadius(12)
                            .shadow(radius: 10)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 16)
                // Güncelleme başarılı olduktan sonra yönlendirme
                .navigationBarTitle("Ürünü Düzenle", displayMode: .inline)
                           .navigationBarItems(trailing: Button("Kapat") {
                               presentationMode.wrappedValue.dismiss()
                           })
            }

        }
    }
}

// Önizleme
struct EditProductView_Previews: PreviewProvider {
    @State static var isUserLoggedIn = true // Burada isUserLoggedIn için bir @State değişkeni oluşturuyoruz

    static var previews: some View {
        EditProductView(
            product: DynamicProduct(
                id: "1",
                name: "Örnek Ürün",
                description: "Açıklama",
                price: 12.0,
                discounted_price: 10.0,
                grammage: "1.0",
                expiry_date: Date(),
                image_url: "",
                category: ""
            )
        )
    }
}
