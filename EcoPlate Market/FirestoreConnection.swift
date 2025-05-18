//
//  FirestoreConnection.swift
//  EcoPlate Market
//
//  Created by Burcu Kamilçelebi on 18.05.2025.
//

import Foundation

import FirebaseFirestore

func testFirestoreConnection() {
    let db = Firestore.firestore()
    db.collection("test").addDocument(data: ["message": "Firestore bağlantısı başarılı!"]) { error in
        if let error = error {
            print("Firestore Hata: \(error.localizedDescription)")
        } else {
            print("Firestore bağlantısı başarılı! ✅")
        }
    }
}
