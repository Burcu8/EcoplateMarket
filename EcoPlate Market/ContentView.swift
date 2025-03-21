//
//  ContentView.swift
//  EcoPlate Market
//
//  Created by Burcu Kamilçelebi on 17.03.2025.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @State private var isUserLoggedIn = false  // İlk başta false olarak başlat

    var body: some View {
        if isUserLoggedIn {
            HomeView(isUserLoggedIn: $isUserLoggedIn)  // Giriş yapılmışsa HomeView'ı göster
        } else {
            LoginView(isUserLoggedIn: $isUserLoggedIn)  // Giriş yapılmamışsa LoginView'ı göster
        }
    }

    init() {
        checkUserSession()  // Oturum kontrolünü başlat
    }

    func checkUserSession() {
        if Auth.auth().currentUser != nil {
            isUserLoggedIn = true  // Eğer kullanıcı oturum açmışsa, HomeView'a yönlendir
        }
    }
}

