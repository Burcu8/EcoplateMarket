//
//  Order.swift
//  EcoPlate Market
//
//  Created by Burcu Kamilçelebi on 16.05.2025.
//

import Foundation
import FirebaseFirestore

struct Orders: Identifiable {
    var id: String
    var createdAt: Date
    var status: String
    var total: Double
    var items: [OrderItem]

    init(id: String, data: [String: Any], currentMarketId: String) {
        self.id = id
        self.createdAt = (data["created_at"] as? Timestamp)?.dateValue() ?? Date()
        self.status = data["status"] as? String ?? "pending"

        // Market'e özel toplam
        if let marketTotals = data["market_totals"] as? [String: Any],
           let total = marketTotals[currentMarketId] as? Double {
            self.total = total
        } else {
            self.total = 0
        }

        // Sadece bu markete ait ürünleri filtrele
        var filteredItems: [OrderItem] = []
        if let rawItems = data["items"] as? [[String: Any]] {
            for itemData in rawItems {
                if itemData["market_id"] as? String == currentMarketId {
                    filteredItems.append(OrderItem(data: itemData))
                }
            }
        }
        self.items = filteredItems
    }
}

struct OrderItem: Identifiable {
    var id: String
    var name: String
    var price: Double
    var quantity: Int

    init(data: [String: Any]) {
        self.id = data["id"] as? String ?? UUID().uuidString
        self.name = data["name"] as? String ?? ""
        self.price = data["price"] as? Double ?? 0.0
        self.quantity = data["quantity"] as? Int ?? 1
    }
}
