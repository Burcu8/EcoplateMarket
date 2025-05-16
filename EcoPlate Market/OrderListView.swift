//
//  OrderListView.swift
//  EcoPlate Market
//
//  Created by Burcu Kamilçelebi on 16.05.2025.
//

// OrderListView.swift

import SwiftUI


struct OrderListView: View {
    @StateObject private var orderService = OrderService()
    let currentMarketId: String

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(orderService.orders) { order in
                        VStack(alignment: .leading, spacing: 12) {
                            
                            // Başlık: ID, Durum, Tarih
                            HStack {
                                Text("Sipariş: \(order.id.prefix(6))")
                                    .font(.headline)
                                
                                Spacer()
                                
                                Text(order.status == "delivered" ? "Teslim Edildi" : "Beklemede")
                                    .font(.caption)
                                    .foregroundColor(.white)
                                    .padding(6)
                                    .background(order.status == "delivered" ? Color.primaryA : Color.orange)
                                    .cornerRadius(8)
                            }
                            
                            Text("Tarih: \(order.createdAt.formatted(.dateTime.day().month().hour().minute()))")
                                .font(.caption)
                                .foregroundColor(.gray)

                            // Ürün Listesi
                            ForEach(order.items) { item in
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(item.name)
                                            .font(.subheadline)
                                        
                                        Text("\(item.quantity) x \(item.price, specifier: "%.2f")₺")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                    
                                    Spacer()
                                    
                                    Text("\(item.price * Double(item.quantity), specifier: "%.2f")₺")
                                        .font(.subheadline)
                                }
                            }

                            Divider()

                            // Toplam ve Onay Butonu
                            HStack {
                                Text("Toplam: \(order.total, specifier: "%.2f")₺")
                                    .font(.headline)
                                
                                Spacer()
                                
                                Button(action: {
                                    orderService.markOrderAsDelivered(orderId: order.id)
                                }) {
                                    Text(order.status == "delivered" ? "Teslim Edildi" : "Onayla")
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(order.status == "delivered" ? Color.gray : Color.primaryA)
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                }
                                .disabled(order.status == "delivered")
                            }
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(12)
                        .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
                    }
                }
                .padding()
            }
            .navigationTitle("Siparişler")
            .navigationBarTitleDisplayMode(.inline) // 👈 Bu satır başlığı yukarı taşır
        }
        .onAppear {
            orderService.fetchOrders(for: currentMarketId)
        }
    }
}



#Preview {
    OrderListView(currentMarketId: "wiOiNpZKdLSrLcZG2U6tAG6P1gi2")
}

