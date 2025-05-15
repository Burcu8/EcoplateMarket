//
//  MarketService.swift
//  EcoPlate Market
//
//  Created by Burcu Kamilçelebi on 14.05.2025.
//


import Foundation
import FirebaseFirestore

class MarketService {
    static func fetchMarketInfo(for marketId: String, completion: @escaping (Market?) -> Void) {
        let db = Firestore.firestore()
        let docRef = db.collection("markets").document(marketId)
        
        docRef.getDocument { document, error in
            if let error = error {
                print("Market verisi alınırken hata: \(error)")
                completion(nil)
                return
            }
            
            guard let document = document, document.exists,
                  let data = document.data() else {
                print("Market dökümanı bulunamadı.")
                completion(nil)
                return
            }
            
            let market = Market(
                id: document.documentID,
                name: data["name"] as? String ?? "",
                address: data["address"] as? String ?? "",
                logo_url: data["logo_url"] as? String ?? "",
                email: data["email"] as? String ?? "",
                phone: data["phone"] as? String ?? ""
            )
            
            completion(market)
        }
    }
}
