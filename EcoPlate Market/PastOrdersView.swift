//
//  PastOrderView.swift
//  EcoPlate Market
//
//  Created by Burcu Kamilçelebi on 10.04.2025.
//

import SwiftUI

struct PastOrdersView: View {
    let pastOrders = [
        Order(orderId: "12345", date: "2025-04-08", totalAmount: 30.00, status: "Tamamlandı", productName: "Biber", productImage: "biber"),
        Order(orderId: "12346", date: "2025-04-07", totalAmount: 20.00, status: "Tamamlandı", productName: "Zencefil", productImage: "zencefil"),
        Order(orderId: "12347", date: "2025-04-05", totalAmount: 10.00, status: "Tamamlandı", productName: "Elma", productImage: "elma")
    ]
    
    var body: some View {
        VStack {
            Text("Geçmiş Siparişler")
                .font(.title2) // Daha küçük bir font boyutu seçebilirsiniz
                  .bold()
                  .frame(maxWidth: .infinity, alignment: .leading)
                  .padding(.leading) 

            List(pastOrders) { order in
                HStack {
                    // Ürün Görseli
                    Image(order.productImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.trailing, 10)
                    
                    VStack(alignment: .leading) {
                        Text(order.productName)
                            .font(.headline)
                            .foregroundColor(.black)
                        
                        Text("Sipariş No: \(order.orderId)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        Text("Tarih: \(order.date)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        Text("Durum: \(order.status)")
                            .font(.subheadline)
                            .foregroundColor(order.status == "Completed" ? .orange : .primaryA)
                    }
                    
                    Spacer()
                    
                    // Sipariş Tutarı
                    Text("₺\(String(format: "%.2f", order.totalAmount))")
                        .font(.headline)
                        .foregroundColor(.black)
                }
                .padding(.vertical, 10)
            }
            .listStyle(PlainListStyle())
        }
    }
}

struct Order: Identifiable {
    var id = UUID()
    var orderId: String
    var date: String
    var totalAmount: Double
    var status: String
    var productName: String
    var productImage: String
}

struct PastOrdersView_Previews: PreviewProvider {
    static var previews: some View {
        PastOrdersView()
    }
}

