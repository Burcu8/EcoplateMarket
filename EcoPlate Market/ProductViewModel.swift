//
//  ProductViewModel.swift
//  EcoPlate Market
//
//  Created by Burcu Kamilçelebi on 12.05.2025.
//

import Foundation
import FirebaseFirestore

class ProductViewModel: ObservableObject {
    @Published var products: [DynamicProduct] = []
    @Published var errorMessage: String?

    func fetchProducts(for marketId: String) {
        let db = Firestore.firestore()
        db.collection("markets").document(marketId).collection("products").getDocuments { snapshot, error in
            if let error = error {
                print("Firestore hata: \(error.localizedDescription)")
                return
            }

            guard let docs = snapshot?.documents else { return }

            self.products = docs.compactMap { doc -> DynamicProduct? in
                let data = doc.data()

                guard
                    let name = data["name"] as? String,
                    let description = data["description"] as? String,
                    let price = data["price"] as? Double,
                    let discounted_price = data["discounted_price"] as? Double,
                    let grammage = data["grammage"] as? String,
                    let expiry_date = data["expiry_date"] as? Date,
                    let image_url = data["image_url"] as? String,
                    let category = data["category"] as? String
                else {
                    print("Eksik veya hatalı alanlar var: \(doc.documentID)")
                    return nil
                }

                return DynamicProduct(
                    id: doc.documentID,
                    name: name,
                    description: description,
                    price: price,
                    discounted_price: discounted_price,
                    grammage: grammage,
                    expiry_date: expiry_date,
                    image_url: image_url,
                    category: category
                )
            }
        }
    }
}

