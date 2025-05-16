//
//  EcoPlate_MarketApp.swift
//  EcoPlate Market
//
//  Created by Burcu Kamilçelebi on 17.03.2025.
//

import SwiftUI
import Firebase
import FirebaseAuth

@main
struct EcoPlate_MarketApp: App {
    @State private var currentMarketId: String? = nil

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            if let marketId = currentMarketId {
                ContentView(currentMarketId: marketId)
                    .preferredColorScheme(.light)
                    .onAppear {
                        testFirestoreConnection()
                    }
            } else {
                LoadingView()
                    .onAppear {
                        getCurrentMarketId()
                    }
            }
        }
    }

    func getCurrentMarketId() {
        if let user = Auth.auth().currentUser {
            // UID'yi currentMarketId olarak kullanıyoruz (örnek senaryo)
            _currentMarketId.wrappedValue = user.uid
        } else {
            // Oturum açılmamışsa UID yoktur
            print("Kullanıcı oturum açmamış")
        }
    }
}

struct LoadingView: View {
    var body: some View {
        VStack {
            ProgressView()
            Text("Yükleniyor...")
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



