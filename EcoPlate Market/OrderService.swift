//
//  OrderService.swift
//  EcoPlate Market
//
//  Created by Burcu Kamilçelebi on 16.05.2025.
//

import Foundation
import FirebaseFirestore

class OrderService: ObservableObject {
    private let db = Firestore.firestore()
    private let ordersCollection = "orders"

    @Published var orders: [Orders] = []

    // MARKET ID'ye göre siparişleri çek
    func fetchOrders(for marketId: String) {
        db.collection(ordersCollection).addSnapshotListener { snapshot, error in
            guard let documents = snapshot?.documents else {
                print("Siparişler alınamadı: \(error?.localizedDescription ?? "Hata")")
                return
            }

            var tempOrders: [Orders] = []

            for doc in documents {
                let data = doc.data()
                // Sipariş market_ids içinde bu market varsa göster
                if let marketIds = data["market_ids"] as? [String], marketIds.contains(marketId) {
                    let order = Orders(id: doc.documentID, data: data, currentMarketId: marketId)
                    tempOrders.append(order)
                }
            }

            DispatchQueue.main.async {
                self.orders = tempOrders
            }
        }
    }

    // Sipariş durumunu "delivered" olarak güncelle
    func markOrderAsDelivered(orderId: String) {
        db.collection(ordersCollection).document(orderId).updateData([
            "status": "delivered",
            "updated_at": FieldValue.serverTimestamp()
        ]) { error in
            if let error = error {
                print("Sipariş güncellenemedi: \(error.localizedDescription)")
            } else {
                print("Sipariş teslim edildi olarak işaretlendi.")
            }
        }
    }
}
