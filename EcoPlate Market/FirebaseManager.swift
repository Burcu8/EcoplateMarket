//
//  FirebaseManager.swift
//  EcoPlate Market
//
//  Created by Burcu Kamilçelebi on 11.04.2025.
//

import Foundation
import Firebase
import FirebaseFirestore
import SwiftUI
import FirebaseAuth

class FirebaseManager: ObservableObject {
    @Published var products: [DynamicProduct] = []
    @Published var errorMessage: String?

    init() {
        fetchProductsForCurrentUser()
    }

    func fetchProductsForCurrentUser() {
        guard let marketid = Auth.auth().currentUser?.uid else {
            print("Kullanıcı giriş yapmamış.")
            return
        }

        let db = Firestore.firestore()
        let productsRef = db.collection("markets").document(marketid).collection("products")

        productsRef.getDocuments { snapshot, error in
            if let error = error {
                print("Ürünler alınırken hata: \(error.localizedDescription)")
                return
            }

            guard let documents = snapshot?.documents else { return }

            DispatchQueue.main.async {
                self.products = documents.compactMap { doc -> DynamicProduct? in
                    let data = doc.data()
                    
                    guard
                        let name = data["name"] as? String,
                        let description = data["description"] as? String,
                        let discounted_price = data["discounted_price"] as? Double,
                        let price = data["price"] as? Double,
                        let grammage = data["grammage"] as? String,
                        // Burada Timestamp'i Date'e dönüştürüyoruz
                        let expiry_date = (data["expiry_date"] as? Timestamp)?.dateValue(),
                        let image_url = data["image_url"] as? String,
                        let category = data["category"] as? String
                    else {
                        print("Veri eksik veya tür uyuşmazlığı.")
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

    
    // MARK: - Firestore'dan Anlık Güncellemeleri Dinleme
    func listenForProductChanges() {
        guard let marketid = Auth.auth().currentUser?.uid else {
            self.errorMessage = "Kullanıcı giriş yapmamış."
            print(self.errorMessage ?? "")
            return
        }
        let db = Firestore.firestore()
        let productsRef = db.collection("markets").document(marketid).collection("products")

        productsRef.addSnapshotListener { snapshot, error in
            if let error = error {
                self.errorMessage = "Veri dinleme hatası: \(error.localizedDescription)"
                print(self.errorMessage ?? "")
                return
            }

            self.products = snapshot?.documents.compactMap { document in
                self.mapDocumentToProduct(document)
            } ?? []

            print("Updated Products: \(self.products)")
        }
    }

    
    private func mapDocumentToProduct(_ document: QueryDocumentSnapshot) -> DynamicProduct? {
        let data = document.data()
        
        guard let name = data["name"] as? String,
              let description = data["description"] as? String,
              let discounted_price = data["discounted_price"] as? Double,
              let price = data["price"] as? Double,
              let grammage = data["grammage"] as? String,
              // Timestamp -> Date dönüşümü burada da yapılmalı
              let expiry_date = (data["expiry_date"] as? Timestamp)?.dateValue(),
              let image_url = data["image_url"] as? String,
              let category = data["category"] as? String else {
            print("Eksik ya da hatalı veri: \(document.documentID)")
            return nil
        }
        
        return DynamicProduct(id: document.documentID,
                              name: name,
                              description: description,
                              price: price,
                              discounted_price: discounted_price,
                              grammage: grammage,
                              expiry_date: expiry_date,  // Date türünde
                              image_url: image_url,
                              category: category)
    }
}


