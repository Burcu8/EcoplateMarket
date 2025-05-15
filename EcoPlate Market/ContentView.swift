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
    @State private var isLoading = true // Eklendi
    @StateObject private var globalState = GlobalState()

    var body: some View {
        Group {
            if isLoading {
                ProgressView("Yükleniyor...")
            } else if isUserLoggedIn {
                HomeView(isUserLoggedIn: $isUserLoggedIn)
            } else {
                LoginView(isUserLoggedIn: $isUserLoggedIn)
                    .environmentObject(globalState)
            }
        }
        .onAppear {
            checkUserSession()
        }
        .onChange(of: isUserLoggedIn) { newValue in
            if !newValue {
                signOutUser()
            }
        }
    }

    func checkUserSession() {
        Auth.auth().addStateDidChangeListener { auth, user in
            DispatchQueue.main.async {
                self.isUserLoggedIn = user != nil
                self.isLoading = false // Oturum kontrolü tamamlandı
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

