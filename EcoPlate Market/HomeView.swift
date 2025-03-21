//
//  HomeView.swift
//  EcoPlate Market
//
//  Created by Burcu Kamilçelebi on 17.03.2025.
//
import SwiftUI
import FirebaseAuth

struct HomeView: View {
    @Binding var isUserLoggedIn: Bool
    
    var body: some View {
        TabView {
            // Mağaza Sekmesi
            StoreView()
                .tabItem {
                    VStack {
                        Image(systemName: "storefront")
                        Text("Mağaza")
                    }
                }
            
            // Ürün İşlemleri Sekmesi
            BulkProductUploadView()
                .tabItem {
                    VStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Ürün İşlemleri")
                    }
                }
            
            // Hesap Sekmesi
            AccountView(isUserLoggedIn: $isUserLoggedIn)
                .tabItem {
                    VStack {
                        Image(systemName: "person.crop.circle")
                        Text("Hesap")
                    }
                }
        }
        .accentColor(.green)
    }
}

struct StoreView: View {
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.gray)
                    
                    VStack(alignment: .leading) {
                        Text("Alpur Market")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Text("alpugrdal@gmail.com")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    Text("+0212 216 5115")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding([.leading, .trailing])
                
                Divider().padding(.top, 0)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        CategorySection(title: "Ürünlerim", products: sampleProducts)
                        CategorySection(title: "Çok Satan Ürünlerim", products: sampleProducts)
                        CategorySection(title: "Özel Tekliflerim", products: sampleProducts)
                    }
                    .padding(.top, 10)
                }
            }
        }
    }
}

struct CategorySection: View {
    var title: String
    var products: [Product]
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(title)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .padding(.horizontal)
                    .padding(.top, 10)
                    .background(Color.white)
                
                Spacer()
                Button(action: {}) {
                    Text("Tümünü Gör")
                        .font(.footnote)
                        .foregroundColor(.black)
                        .padding(.trailing)
                        .padding(.top, 10)
                }
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(products) { product in
                        NavigationLink(destination: ProductDetailView(product: product)) {
                            ProductCardView(product: product)
                        }
                    }
                }
                .padding()
            }
        }
    }
}

struct Product: Identifiable {
    var id = UUID()
    var name: String
    var price: String
    var oldPrice: String
    var imageName: String
    var skt: String
    var kg: String
}

let sampleProducts = [
    Product(name: "Dolmalık Kırmızı Biber", price: "19.99", oldPrice: "39.99", imageName: "biber", skt: "24.03.2025", kg: "1"),
    Product(name: "Zencefil", price: "5.99", oldPrice: "13.99", imageName: "zencefil", skt: "24.03.2025", kg: "1"),
    Product(name: "Organik Muz", price: "34.99", oldPrice: "69.99", imageName: "organik muz", skt: "24.03.2025", kg: "1"),
    Product(name: "Doğal Kırmızı Elma", price: "19.99", oldPrice: "49.99", imageName: "elma", skt: "24.03.2025", kg: "1")
]

struct ProductCardView: View {
    var product: Product
    
    var body: some View {
        VStack {
            Image(product.imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 120)
                .clipped()
                .offset(y: -15)
            
            Text(product.name)
                .font(.headline)
                .multilineTextAlignment(.center)
                .foregroundColor(.black)
                .padding(.top, -20)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("\(product.kg)kg, fiyat")
                .font(.system(size: 17))
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(product.skt)
                .font(.system(size: 12))
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack {
                if product.price != product.oldPrice {
                    Text("₺\(product.oldPrice)")
                        .font(.system(size: 18))
                        .strikethrough()
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 1)
                        .offset(y: 15)
                }
                
                Text("₺\(product.price)")
                    .font(.system(size: 22))
                    .bold()
                    .foregroundColor(.green)
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
}

struct ProductDetailView: View {
    var product: Product
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) { // spacing artırıldı
            // Resim kısmı, ortada
            HStack {
                Spacer()
                Image(product.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 280) // Fotoğraf biraz büyütüldü
                    .clipped()
                Spacer()
            }
            .padding(.top, -10) // Fotoğrafı biraz yukarı çekelim

            // Alt kısımda ürün detayları, sola yasla
            VStack(alignment: .leading, spacing: 5) { // spacing artırıldı
                // Ürün adı
                Text(product.name)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 5)
                
                // Ürün kilogram ve fiyat
                Text("\(product.kg) kg, fiyat")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                // SKT tarihi
                Text("SKT: \(product.skt)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                HStack(spacing: 15) { // Fiyatlar arasına boşluk ekledik
                    if product.price != product.oldPrice {
                        Text("₺\(product.oldPrice)")
                            .font(.body)
                            .strikethrough()
                            .foregroundColor(.gray)
                                                     
                        Text("₺\(product.price)")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                    }
                }
                
                Divider().padding(.vertical, 5)

                // Ürün açıklaması başlığı ve metni
                VStack(alignment: .leading, spacing: 10) {
                    Text("Ürün Detayı")
                        .font(.headline)
                                        
                    Text("3 gün içerisinde tüketilmeli ve buzdolabında saklanması tavsiye edilir.")
                        .font(.body)
                        .foregroundColor(.gray)
                }
                
                Divider().padding(.vertical, 5)

                // Besin Bilgisi
                HStack {
                    Text("Besin Bilgisi")
                        .font(.headline)
                                        
                    Spacer()
                                        
                    Text("100g")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.gray.opacity(0.8)) // Gri arka plan
                        .clipShape(Capsule()) // Oval şekil verildi
                        .frame(maxWidth: 70, alignment: .trailing)
                }
                
                Divider().padding(.vertical, 5)

                // Değerlendirme Yıldızları
                HStack(spacing: 12) { // Yıldızlar arasına daha fazla boşluk ekledik
                    Text("Değerlendirme")
                        .font(.headline)
                    
                    Spacer() // Yıldızları sağa yaslamak için

                    ForEach(0..<4, id: \.self) { _ in
                        Image(systemName: "star.fill") // Dolu yıldız
                            .foregroundColor(.yellow) // Sarı renk
                            .font(.title3) // Yıldız boyutu
                    }
                }
            }
            .padding(.horizontal, 20) // Sol ve sağ boşluklar artırıldı
            .padding(.bottom, 25) // Alt boşluk artırıldı
        }
        .navigationBarTitle("Ürün Detayı", displayMode: .inline)
    }
}


struct HomeView_Previews: PreviewProvider {
    @State static var isUserLoggedIn = true
    
    static var previews: some View {
        HomeView(isUserLoggedIn: $isUserLoggedIn)
    }
}
