//
//  EcoPlate_MarketApp.swift
//  EcoPlate Market
//
//  Created by Burcu Kamilçelebi on 17.03.2025.
//

import SwiftUI
import Firebase

@main
struct EcoPlate_MarketApp: App {
    
    
    
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.light)
                .onAppear {
                    testFirestoreConnection()
                }
        }
    }
}

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


