//
//  ContentView.swift
//  EcoPlate Market
//
//  Created by Burcu Kamilçelebi on 17.03.2025.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @State private var isUserLoggedIn = false
    @State private var isLoading = true
    @State private var currentMarketId: String? = nil
    @StateObject private var globalState = GlobalState()

    var body: some View {
        Group {
            if isLoading {
                LoadingView()
            } else if isUserLoggedIn, let marketId = currentMarketId {
                HomeView(isUserLoggedIn: $isUserLoggedIn, currentMarketId: marketId)
            } else {
                LoginView(isUserLoggedIn: $isUserLoggedIn)
                    .environmentObject(globalState)
            }
        }
        .onAppear {
            Auth.auth().addStateDidChangeListener { _, user in
                DispatchQueue.main.async {
                    if let user = user {
                        self.currentMarketId = user.uid
                        self.isUserLoggedIn = true
                        testFirestoreConnection()
                    } else {
                        self.isUserLoggedIn = false
                    }
                    self.isLoading = false
                }
            }
        }
    }

    func signOutUser() {
        do {
            try Auth.auth().signOut()
            print("User signed out successfully")
        } catch let error {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}

