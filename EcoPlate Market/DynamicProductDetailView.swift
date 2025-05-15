//
//  DynamicProductDetailView.swift
//  EcoPlate Market
//
//  Created by Burcu Kamilçelebi on 11.04.2025.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

struct DynamicProductDetailView: View {
    @State private var product: DynamicProduct
    @Environment(\.presentationMode) var presentationMode
    @State private var showEditView = false
    @Binding var isUserLoggedIn: Bool
    
    init(product: DynamicProduct, isUserLoggedIn: Binding<Bool>) {
        _product = State(initialValue: product)
        _isUserLoggedIn = isUserLoggedIn
    }

    // Firestore'dan ürünü yeniden yükleyen fonksiyon
    func reloadProduct() {
        guard let marketid = Auth.auth().currentUser?.uid else {
            print("Kullanıcı oturumu bulunamadı.")
            return
        }

        guard let productId = product.id else {
            print("Ürün ID'si bulunamadı.")
            return
        }

        let db = Firestore.firestore()
        let productRef = db.collection("markets").document(marketid).collection("products").document(productId)

        productRef.getDocument { snapshot, error in
            if let error = error {
                print("Hata: \(error.localizedDescription)")
                return
            }
            guard let data = snapshot?.data() else {
                print("Veri bulunamadı")
                return
            }

            DispatchQueue.main.async {
                self.product.name = data["name"] as? String ?? self.product.name
                self.product.description = data["description"] as? String ?? self.product.description
                self.product.price = data["price"] as? Double ?? self.product.price
                self.product.discounted_price = data["discounted_price"] as? Double ?? self.product.discounted_price
                self.product.grammage = data["grammage"] as? String ?? self.product.grammage
                self.product.image_url = data["image_url"] as? String ?? self.product.image_url
                self.product.category = data["category"] as? String ?? self.product.category

                if let timestamp = data["expiry_date"] as? Timestamp {
                    self.product.expiry_date = timestamp.dateValue()
                }
            }
        }
    }


    
    func deleteProduct(productID: String) {
        guard let marketid = Auth.auth().currentUser?.uid else {
            print("Kullanıcı oturumu bulunamadı.")
            return
        }

        let db = Firestore.firestore()
        let storage = Storage.storage()
        let productRef = db.collection("markets").document(marketid).collection("products").document(productID)

        // Firebase Storage'daki ürüne ait görselin yolunu alıyoruz
        let imageRef = storage.reference().child("products/\(productID)/main.jpg")

        // Resmi Firebase Storage'dan silmeden önce Firestore'dan ürünü silmeye çalışıyoruz
        productRef.delete { error in
            if let error = error {
                print("Ürün silinemedi: \(error.localizedDescription)")
            } else {
                print("Ürün başarıyla silindi.")
                
                // Firestore'dan ürün silindikten sonra resim silme işlemi
                imageRef.delete { error in
                    if let error = error {
                        print("Resim silinemedi: \(error.localizedDescription)")
                    } else {
                        print("Resim başarıyla silindi.")
                        // Ürün ve fotoğraf silme işlemi tamamlandığında sayfayı kapat
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }


    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {

            // ÜRÜN GÖRSELİ
            HStack {
                Spacer()
                
                if let url = URL(string: product.image_url) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(maxWidth: 300, maxHeight: 280)
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit) // Görselin oranını koruyarak sığdırır
                                .frame(maxWidth: 300, maxHeight: 280) // Maksimum sınır belirlenir
                                .clipped()
                        case .failure:
                            Image(systemName: "photo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: 300, maxHeight: 280)
                                .foregroundColor(.gray)
                        @unknown default:
                            EmptyView()
                        }
                    }
                }
                Spacer()
            }
            .padding(.top, -10)
            
            // ÜRÜN BİLGİLERİ
            VStack(alignment: .leading, spacing: 5) {
                Text(product.name)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 5)
                
                Text("\(product.grammage), fiyat")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Text("SKT: \(formattedDate(product.expiry_date))")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                HStack(spacing: 15) {
                    if product.discounted_price != product.price {
                        Text("₺\(String(format: "%.2f", product.price))")
                            .font(.body)
                            .strikethrough()
                            .foregroundColor(.gray)
                    }
                    
                    Text("₺\(String(format: "%.2f", product.discounted_price))")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                }
                
                Divider().padding(.vertical, 5)
                
                // ÜRÜN DETAYI
                VStack(alignment: .leading, spacing: 10) {
                    Text("Ürün Detayı")
                        .font(.headline)
                    Text(product.description)
                        .font(.body)
                        .foregroundColor(.gray)
                }
                
                Divider().padding(.vertical, 5)
                
                // BESİN BİLGİSİ
                HStack {
                    Text("Besin Bilgisi")
                        .font(.headline)
                    Spacer()
                    Text("\(product.grammage) g")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.gray.opacity(0.8))
                        .clipShape(Capsule())
                        .frame(maxWidth: 70, alignment: .trailing)
                }
                
                Divider().padding(.vertical, 5)
                
                
                
                // DEĞERLENDİRME
                HStack(spacing: 12) {
                    Text("Değerlendirme")
                        .font(.headline)
                    Spacer()
                    ForEach(0..<4, id: \.self) { _ in
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.title3)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 25)
            
            HStack(spacing: 20) {
                Button(action: {
                    if let productId = product.id {
                        deleteProduct(productID: productId)
                    } else {
                        print("Ürün ID'si bulunamadı.")
                    }
                })  {
                    Text("Ürünü Sil")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity) // Eşit genişlik
                        .background(Color.red)
                        .cornerRadius(10)
                }

                Button(action: {
                    showEditView = true
                }) {
                    Text("Ürünü Düzenle")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity) // Eşit genişlik
                        .background(Color.primaryA)
                        .cornerRadius(10)
                }
            }
            .padding()
            .sheet(isPresented: $showEditView) {
                EditProductView(product: product)
            }
            .onAppear {
                reloadProduct()  // Sayfa her görüntülendiğinde Firestore'dan veriyi yeniden yükle
            }

        }
        
        .navigationBarTitle("Ürün Detayı", displayMode: .inline)
    }
    func formattedDate(_ date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            return formatter.string(from: date)
    }
}

struct DynamicProductDetailView_Previews: PreviewProvider {
    @State static var isUserLoggedIn = true
    static var previews: some View {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let createdAtDate = dateFormatter.date(from: "2025-01-01") ?? Date() // Eğer dönüştürülemezse bugünün tarihini kullan
        
        return DynamicProductDetailView(product: DynamicProduct(
            id: "1",
            name: "Örnek Ürün",
            description: "Bu ürün, yüksek kaliteli malzemelerden üretilmiştir.",
            price: 20.00,
            discounted_price: 15.99,
            grammage: "1.5",
            expiry_date: Date(),
            image_url: "https://via.placeholder.com/150",
            category: "Meyve"
        ),
        isUserLoggedIn: $isUserLoggedIn // @Binding parametreyi bağlıyoruz
        )
    }
}
