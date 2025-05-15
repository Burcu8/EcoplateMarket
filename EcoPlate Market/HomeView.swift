//
//  HomeView.swift
//  EcoPlate Market
//
//  Created by Burcu Kamilçelebi on 17.03.2025.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

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
        .accentColor(.primaryA)
    }
}

struct StoreView: View {
    @StateObject private var firebaseManager = FirebaseManager()
    @State private var products: [DynamicProduct] = []
    @State private var selectedCategory: String = "Meyve"
    @State private var searchText: String = ""
    @StateObject private var viewModel = MarketViewModel()
    
    var filteredDynamicProducts: [DynamicProduct] {
        if searchText.isEmpty {
            return firebaseManager.products
        } else {
            return firebaseManager.products.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }

    var filteredStaticProducts: [Product] {
        if searchText.isEmpty {
            return sampleProducts
        } else {
            return sampleProducts.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 10) {

                // 🔽 MARK: MARKET BİLGİLERİ
                HStack {
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

                    VStack(alignment: .leading) {
                        Text(viewModel.market?.name ?? "Market Adı")
                            .font(.headline)
                            .foregroundColor(.gray)

                        Text(viewModel.market?.email ?? "Email")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }

                    Spacer()

                    Text(viewModel.market?.phone ?? "Telefon")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding([.leading, .trailing])

                Divider().padding(.top, 0)

                TextField("Mağazada Ara...", text: $searchText)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal)

                CategorySelectorView(selectedCategory: $selectedCategory)

                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        CategorySection(title: "Ürünlerim", products: filteredDynamicProducts, isDynamic: true)
                        CategorySection(title: "Çok Satan Ürünler", products: sampleProducts, isDynamic: false)
                        CategorySection(title: "Özel Tekliflerim", products: sampleProducts, isDynamic: false)
                    }
                    .padding(.top, 1)
                }
            }
            .onAppear {
                firebaseManager.fetchProductsForCurrentUser()
                
                // ✅ Kullanıcının UID’siyle market verisi çek
                if let currentUserId = Auth.auth().currentUser?.uid {
                    viewModel.loadMarket(marketId: currentUserId)
                } else {
                    print("Kullanıcı girişi yapılmamış.")
                }
            }
        }
    }
}



struct CategorySection<T: Identifiable>: View {
    var title: String
    var products: [T]
    var isDynamic: Bool
    @State private var isUserLoggedIn = true

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

                // "Tümünü Gör" butonu
                NavigationLink(destination: AllProductsView(products: products, isDynamic: isDynamic)) {
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
                        // DynamicProduct için işlem
                        if let dynamicProduct = product as? DynamicProduct {
                            NavigationLink(destination: DynamicProductDetailView(product: dynamicProduct, isUserLoggedIn: $isUserLoggedIn)) {
                                DynamicProductCardView(product: dynamicProduct)
                            }
                        }
                        // Product (Statik) için işlem
                        else if let staticProduct = product as? Product {
                            NavigationLink(destination: ProductDetailView(product: staticProduct)) {
                                ProductCardView(product: staticProduct)
                            }
                        }
                    }
                }
                .padding() // Padding ekleyerek margin ekledik
            }

        }
    }
}


struct Product: Identifiable, Codable {
    var id: String
    var name: String
    var price: String
    var oldPrice: String
    var imageName: String
    var skt: String
    var kg: String
    let category: String
}

let sampleProducts = [
    Product(id: "1", name: "Dolmalık Kırmızı Biber", price: "19.99", oldPrice: "39.99", imageName: "biber", skt: "24.03.2025", kg: "1", category: "Sebze"),
    Product(id: "2", name: "Zencefil", price: "5.99", oldPrice: "13.99", imageName: "zencefil", skt: "24.03.2025", kg: "1", category: "Sebze"),
    Product(id: "3", name: "Organik Muz", price: "34.99", oldPrice: "69.99", imageName: "organik muz", skt: "24.03.2025", kg: "1", category: "Meyve"),
    Product(id: "4", name: "Doğal Kırmızı Elma", price: "19.99", oldPrice: "49.99", imageName: "elma", skt: "24.03.2025", kg: "1",category: "Meyve")
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
}

struct ProductDetailView: View {
    var product: Product
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Spacer()
                Image(product.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 280)
                    .clipped()
                Spacer()
            }
            .padding(.top, -10)

            VStack(alignment: .leading, spacing: 5) {
                Text(product.name)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 5)
                
                Text("\(product.kg) kg, fiyat")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Text("SKT: \(product.skt)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                HStack(spacing: 15) {
                    if product.price != product.oldPrice {
                        Text("₺\(product.oldPrice)")
                            .font(.body)
                            .strikethrough()
                            .foregroundColor(.gray)
                    }
                    
                    Text("₺\(product.price)")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                }
                
                Divider().padding(.vertical, 5)

                VStack(alignment: .leading, spacing: 10) {
                    Text("Ürün Detayı")
                        .font(.headline)
                    Text("3 gün içerisinde tüketilmeli ve buzdolabında saklanması tavsiye edilir.")
                        .font(.body)
                        .foregroundColor(.gray)
                }
                
                Divider().padding(.vertical, 5)

                HStack {
                    Text("Besin Bilgisi")
                        .font(.headline)
                    Spacer()
                    Text("100g")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.gray.opacity(0.8))
                        .clipShape(Capsule())
                        .frame(maxWidth: 70, alignment: .trailing)
                }
                
                Divider().padding(.vertical, 5)

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
        }
        .navigationBarTitle("Ürün Detayı", displayMode: .inline)
    }
}

struct AllProductsView<T: Identifiable>: View {
    var products: [T]
    var isDynamic: Bool
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(products) { product in
                    if isDynamic, let dynamicProduct = product as? DynamicProduct {
                        DynamicProductCardView(product: dynamicProduct)
                    } else if let staticProduct = product as? Product {
                        ProductCardView(product: staticProduct)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Tüm Ürünler")
    }

}

struct ProductListView: View {
    var selectedCategory: String  // Seçilen kategori dışarıdan alınıyor

    let allProducts: [Product] = [
        Product(id: "1", name: "Elma", price: "19.99", oldPrice: "29.99", imageName: "elma", skt: "12.05.2025", kg: "1", category: "Meyve"),
        Product(id: "2", name: "Havuç", price: "8.99", oldPrice: "12.99", imageName: "havuç", skt: "15.05.2025", kg: "1", category: "Sebze"),
        Product(id: "3", name: "Portakal", price: "14.99", oldPrice: "22.99", imageName: "portakal", skt: "18.05.2025", kg: "1", category: "Meyve"),
        Product(id: "4", name: "Kola", price: "10.99", oldPrice: "15.99", imageName: "kola", skt: "10.07.2025", kg: "1", category: "İçecek")
    ]
    
    var filteredProducts: [Product] {
        allProducts.filter { $0.category == selectedCategory }
    }
    
    var body: some View {
        // Ürün kartları
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                ForEach(filteredProducts) { product in
                    ProductCardView(product: product)
                }
            }
            .padding()
        }
    }
}




struct HomeView_Previews: PreviewProvider {
    @State static var isUserLoggedIn = true
    
    static var previews: some View {
        HomeView(isUserLoggedIn: $isUserLoggedIn)
    }
}

