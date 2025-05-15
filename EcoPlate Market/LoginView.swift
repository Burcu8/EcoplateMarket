//
//  LoginView.swift
//  EcoPlate Market
//
//  Created by Burcu Kamilçelebi on 17.03.2025.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

// Global State sınıfı
class GlobalState: ObservableObject {
    @Published var showAlert = false
    @Published var alertMessage = ""
}

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false  // Eksikti, eklendi
    @Binding var isUserLoggedIn: Bool  // Parent view'dan geliyor
    
    @EnvironmentObject var globalState: GlobalState  // Global alert durumu

    var body: some View {
        NavigationStack {
            VStack {
                VStack(spacing: 16) {
                    Text("Giriş Yap")
                        .font(.title)
                        .bold()
                        .foregroundColor(.primaryA)

                    Text("Ecoplate'e hoş geldin! Sağlıklı ve sürdürülebilir bir yaşam için buradayız. Sen de hemen giriş yap.")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal)

                Divider().padding()

                TextField("E-posta", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding(.leading, 30)
                    .padding(.vertical, 10)
                    .background(
                        ZStack(alignment: .leading) {
                            Image(systemName: "envelope.fill")
                                .foregroundColor(.gray)
                                .padding(.leading, -170)
                        }
                    )
                    .padding(.horizontal)
                    .frame(height: 50)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)

                SecureField("Şifre", text: $password)
                    .padding(.leading, 30)
                    .padding(.vertical, 10)
                    .background(
                        ZStack(alignment: .leading) {
                            Image(systemName: "lock.fill")
                                .foregroundColor(.gray)
                                .padding(.leading, -170)
                        }
                    )
                    .padding(.horizontal)
                    .frame(height: 50)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)

                if isLoading {
                    ProgressView()
                        .padding()
                }

                HStack {
                    Spacer()
                    Text("Şifrenizi mi unuttunuz?")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                .padding(.top, 10)
                .padding(.trailing, 20)

                Button(action: {
                    loginUser(email: email, password: password)
                }) {
                    Text("Giriş Yap")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.primaryA)
                        .cornerRadius(10)
                        .shadow(color: .gray.opacity(0.5), radius: 5, x: 0, y: 4)
                }
                .padding()
            }
            .padding()
            .alert(isPresented: $globalState.showAlert) {
                Alert(title: Text("Uyarı"), message: Text(globalState.alertMessage), dismissButton: .default(Text("Tamam")))
            }
        }
    }

    // MARK: - Login Function
    func loginUser(email: String, password: String) {
        guard !email.isEmpty, !password.isEmpty else {
            globalState.alertMessage = "Email ya da şifre boş bırakılamaz."
            globalState.showAlert = true
            return
        }

        isLoading = true

        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            DispatchQueue.main.async {
                self.isLoading = false

                if let error = error {
                    switch AuthErrorCode(rawValue: error._code) {
                    case .wrongPassword:
                        globalState.alertMessage = "Kullanıcı adı ya da şifre hatalı. Lütfen tekrar deneyin."
                    case .userNotFound:
                        globalState.alertMessage = "Kullanıcı bulunamadı."
                    case .invalidEmail:
                        globalState.alertMessage = "Geçersiz bir mail adresi girdiniz."
                    default:
                        globalState.alertMessage = "Giriş yapılamadı. Lütfen tekrar deneyin."
                    }

                    globalState.showAlert = true
                    return
                }

                if let user = result?.user {
                    fetchMarketData(email: user.email ?? "")
                }
            }
        }
    }

    // MARK: - Firestore: Market hesabı mı kontrol et
    private func fetchMarketData(email: String) {
        let db = Firestore.firestore()

        db.collection("auth")
            .document(email)
            .getDocument { document, error in
                if let error = error {
                    globalState.alertMessage = "Kullanıcı bilgileri alınırken hata oluştu: \(error.localizedDescription)"
                    globalState.showAlert = true
                    return
                }

                guard let document = document, document.exists,
                      let isUser = document.data()?["is_user"] as? Bool else {
                    globalState.alertMessage = "Kullanıcı bilgisi bulunamadı."
                    globalState.showAlert = true
                    return
                }

                if isUser {
                    globalState.alertMessage = "Bu hesap market hesabı değil. Lütfen doğru hesapla giriş yapın."
                    globalState.showAlert = true
                    return
                }

                // Başarılı giriş
                isUserLoggedIn = true
                UserDefaults.standard.set(false, forKey: "isUser")
            }
    }
}

// MARK: - Preview
struct LoginView_Previews: PreviewProvider {
    @State static var isUserLoggedIn = false
    static var previews: some View {
        LoginView(isUserLoggedIn: $isUserLoggedIn)
            .environmentObject(GlobalState()) // environmentObject eklenmeli
    }
}

