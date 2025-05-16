//
//  BulkProductUploadView.swift
//  EcoPlate Market
//
//  Created by Burcu Kamilçelebi on 18.03.2025.
//
import SwiftUI
import PhotosUI
import FirebaseStorage
import FirebaseFirestore
import Firebase
import FirebaseAuth

struct BulkProductUploadView: View {
    @State private var isShowingSheet = false
    @State private var selectedBoxIndex: Int? = nil
    @State private var products: [Product2?] = Array(repeating: nil, count: 9) // Ürünleri tutacak liste
    @State private var showSuccessAlert = false
    @StateObject private var viewModel = MarketViewModel()


    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Profil Alanı
                VStack {
                    if let logoURL = viewModel.market?.logo_url, let url = URL(string: logoURL) {
                        AsyncImage(url: url) { image in
                            image.resizable()
                        } placeholder: {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .foregroundColor(.gray)
                        }
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                    } else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.gray)
                    }
                    
                    Text(viewModel.market?.name.isEmpty == false ? viewModel.market!.name : "Bilinmeyen Market")
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                    Text(viewModel.market?.email.isEmpty == false ? viewModel.market!.email : "test@gmail.com")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.top, 20)

                Divider()

                // Ürün Düzenleme Linki
                NavigationLink(destination: ProductEditView()) {
                    HStack {
                        Text("Tekli Ürün Yükleme")
                            .font(.headline)
                            .foregroundStyle(.gray)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal)
                }

                Divider()

                // Toplu Ürün İşlemleri Başlık
                HStack {
                    Text("Toplu Ürün İşlemleri")
                        .font(.title2)
                        .fontWeight(.bold)
                    Spacer()
                }
                .padding(.leading, 5)

                // 3x3 Kutu Dizilimi
                ForEach(0..<3, id: \.self) { rowIndex in
                    HStack(spacing: 13) {
                        ForEach(0..<3, id: \.self) { columnIndex in
                            let boxIndex = rowIndex * 3 + columnIndex

                            Button(action: {
                                selectedBoxIndex = boxIndex
                                isShowingSheet = true
                            }) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color.gray.opacity(0.6), lineWidth: 2)
                                        .background(Color.white)
                                        .cornerRadius(15)
                                        .shadow(radius: 2)
                                        .frame(width: 105, height: 105)

                                    if let product = products[boxIndex] {
                                        if let productImage = product.image {
                                            Image(uiImage: productImage)
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 115, height: 115)
                                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                        }
                                    } else {
                                        Image(systemName: "plus.circle.fill")
                                            .resizable()
                                            .foregroundColor(.primaryA)
                                            .frame(width: 50, height: 50)
                                    }
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
                
                // Toplu Yükleme Butonu
                Button(action: {
                    uploadProductsToFirebase { result in
                        switch result {
                        case .success:
                            print("Ürünler başarıyla yüklendi!")
                            // Geri bildirim göster, UI'yi güncelle, vb.
                        case .failure(let error):
                            print("Yükleme hatası: \(error.localizedDescription)")
                            // Hata mesajı göster
                        }
                    }
                }) {
                    Text("Toplu Yükle")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.primaryA)
                        .cornerRadius(12)
                        .shadow(radius: 5)
                }
                .padding(.top, 0)

                Spacer()
            }
            .padding()
            .sheet(isPresented: $isShowingSheet) {
                ProductEditSheetView(products: $products, selectedBoxIndex: $selectedBoxIndex)
            
            }
            .alert(isPresented: $showSuccessAlert) {
                Alert(
                    title: Text("Başarılı"),
                    message: Text("Ürünler başarıyla yüklendi."),
                    dismissButton: .default(Text("Tamam")) {
                        products = Array(repeating: nil, count: 9)
                    }
                )
            }

        }
        .navigationTitle("Bulk Product Yükleme")
        .onAppear {
            // Sayfa yüklendiğinde çalışacak işlemler
            if let currentUserId = Auth.auth().currentUser?.uid {
                viewModel.loadMarket(marketId: currentUserId)
            } else {
                print("Kullanıcı girişi yapılmamış.")
            }
        }
    }

    func uploadProductsToFirebase(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let marketid = Auth.auth().currentUser?.uid else {
            print("Kullanıcı giriş yapmamış.")
            completion(.failure(NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Kullanıcı oturum açmamış."])))
            return
        }

        let db = Firestore.firestore()
        let storage = Storage.storage()
        var uploadCount = 0
        let totalToUpload = products.compactMap { $0 }.count

        // Firestore referansları
        let marketRef = db.collection("markets").document(marketid)
        let productsRef = marketRef.collection("products")

        for (index, productOpt) in self.products.enumerated() {
            guard var product = productOpt else { continue }

            product.id = UUID().uuidString

            let productRef = productsRef.document(product.id)
            let imageRef = storage.reference().child("products/\(product.id)/main.jpg")

            if let image = product.image, let imageData = image.jpegData(compressionQuality: 0.8) {
                imageRef.putData(imageData, metadata: nil) { _, error in
                    if let error = error {
                        print("Resim yüklenirken hata: \(error.localizedDescription)")
                        return
                    }

                    imageRef.downloadURL { url, error in
                        if let error = error {
                            print("Resim URL'si alınamadı: \(error.localizedDescription)")
                            return
                        }

                        let imageUrl = url?.absoluteString ?? ""

                        let productData: [String: Any] = [
                            "id": product.id,
                            "name": product.name,
                            "description": product.description,
                            "discounted_price": product.normalPrice,
                            "price": product.oldPrice,
                            "grammage": product.weight,
                            "expiry_date": product.expirationDate,
                            "image_url": imageUrl,
                            "category": product.category
                        ]

                        productRef.setData(productData) { error in
                            if let error = error {
                                print("Ürün verisi kaydedilirken hata: \(error.localizedDescription)")
                            } else {
                                print("✅ Ürün kaydedildi.")
                                self.products[index] = nil // ✅ KUTUYU TEMİZLE
                            }

                            uploadCount += 1
                            if uploadCount == totalToUpload {
                                DispatchQueue.main.async {
                                    self.showSuccessAlert = true
                                }
                                completion(.success(()))
                            }
                        }
                    }
                }
            } else {
                let productData: [String: Any] = [
                    "id": product.id,
                    "name": product.name,
                    "description": product.description,
                    "discounted_price": product.normalPrice,
                    "price": product.oldPrice,
                    "grammage": product.weight,
                    "expiry_date": product.expirationDate,
                    "image_url": "",
                    "category": product.category
                ]

                productRef.setData(productData) { error in
                    if let error = error {
                        print("Ürün verisi kaydedilirken hata: \(error.localizedDescription)")
                    } else {
                        print("✅ Ürün kaydedildi (resimsiz).")
                        self.products[index] = nil // ✅ KUTUYU TEMİZLE
                    }

                    uploadCount += 1
                    if uploadCount == totalToUpload {
                        DispatchQueue.main.async {
                            self.showSuccessAlert = true
                        }
                        completion(.success(()))
                    }
                }
            }
        }
    }
}

struct BulkProductUploadView_Previews: PreviewProvider {
    static var previews: some View {
        BulkProductUploadView()
    }
}
