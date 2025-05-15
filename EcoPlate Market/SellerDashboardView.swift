//
//  SellerDashboardView.swift
//  EcoPlate Market
//
//  Created by Burcu Kamilçelebi on 11.05.2025.
//
import SwiftUI
import Charts

// Örnek veri modelleri
struct DailySale: Identifiable {
    let id = UUID()
    let day: String
    let amount: Double
}

struct ExpiringProduct: Identifiable {
    let id = UUID()
    let name: String
    let daysLeft: Int
}

struct StockItem: Identifiable {
    let id = UUID()
    let name: String
    let quantity: Int
}

// Ana görünüm
struct SellerDashboardView: View {
    
    let salesData: [DailySale] = [
        .init(day: "Pzt", amount: 150),
        .init(day: "Sal", amount: 200),
        .init(day: "Çar", amount: 180),
        .init(day: "Per", amount: 220),
        .init(day: "Cum", amount: 170),
        .init(day: "Cmt", amount: 90),
        .init(day: "Paz", amount: 120)
    ]
    
    let expiringProducts: [ExpiringProduct] = [
        .init(name: "Domates", daysLeft: 2),
        .init(name: "Biber", daysLeft: 5),
        .init(name: "Kola", daysLeft: 10)
    ]
    
    let stockItems: [StockItem] = [
        .init(name: "Havuç", quantity: 8),
        .init(name: "Kola", quantity: 2),
        .init(name: "Makarna", quantity: 0),
        .init(name: "Süt", quantity: 12)
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                
                Text("📊 Satıcı Paneli")
                    .font(.largeTitle)
                    .bold()
                
                // Bilgi Kartları
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    MetricCardView(title: "Toplam Satış", value: "₺940", icon: "creditcard", color: .blue)
                    MetricCardView(title: "Satılan Ürün", value: "30", icon: "cube.box.fill", color: .primary)
                    MetricCardView(title: "En Çok Satan", value: "Havuç", icon: "star.fill", color: .orange)
                    MetricCardView(title: "Ort. Fiyat", value: "₺9,75", icon: "chart.bar", color: .purple)
                }
                
                // Haftalık Satış Grafiği
                Text("🗓️ Haftalık Satış")
                    .font(.title2)
                    .bold()
                
                Chart(salesData) {
                    LineMark(
                        x: .value("Gün", $0.day),
                        y: .value("Satış", $0.amount)
                    )
                    .foregroundStyle(.blue)
                    .interpolationMethod(.catmullRom)
                }
                .frame(height: 200)
                .padding(.horizontal)
                
                // SKT Yaklaşan Ürünler
                Text("⚠️ SKT’si Yaklaşan Ürünler")
                    .font(.title2)
                    .bold()
                
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(expiringProducts) { product in
                        HStack {
                            Text(product.name)
                                .bold()
                            Spacer()
                            Text("\(product.daysLeft) gün kaldı")
                                .foregroundColor(product.daysLeft <= 3 ? .red : (product.daysLeft <= 7 ? .orange : .primary))
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    }
                }
                
                // Stok Kontrolü
                Text("📦 Stok Kontrolü")
                    .font(.title2)
                    .bold()
                
                VStack(spacing: 12) {
                    ForEach(stockItems) { item in
                        StockCardView(item: item)
                    }
                }
            }
            .padding()
        }
    }
}

// Bilgi kartı bileşeni
struct MetricCardView: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.white)
                .padding(10)
                .background(color)
                .clipShape(Circle())
            VStack(alignment: .leading) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.gray)
                Text(value)
                    .font(.headline)
            }
            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

// Stok kartı bileşeni
struct StockCardView: View {
    let item: StockItem

    var statusText: String {
        if item.quantity == 0 {
            return "Stok Yok"
        } else if item.quantity <= 5 {
            return "Düşük Stok"
        } else {
            return "Yeterli Stok"
        }
    }

    var statusColor: Color {
        if item.quantity == 0 {
            return .red
        } else if item.quantity <= 5 {
            return .orange
        } else {
            return .primaryA
        }
    }

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "shippingbox.fill")
                .font(.title)
                .foregroundColor(.white)
                .padding()
                .background(statusColor)
                .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.headline)

                Text("\(item.quantity) adet")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Text(statusText)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(statusColor.opacity(0.2))
                    .foregroundColor(statusColor)
                    .clipShape(Capsule())
            }

            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 1)
    }
}

// Önizleme
#Preview {
    SellerDashboardView()
}
