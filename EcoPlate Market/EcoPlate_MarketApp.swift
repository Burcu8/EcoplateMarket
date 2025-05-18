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
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView() // Artık marketId burada değil
                .preferredColorScheme(.light)
        }
    }
}


