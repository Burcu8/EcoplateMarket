//
//  SignUpView.swift
//  EcoPlate Market
//
//  Created by Burcu Kamilçelebi on 17.03.2025.
//

import SwiftUI
import FirebaseAuth

struct SignUpView: View {
    @Binding var isUserLoggedIn: Bool
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var errorMessage: String?
    
    var body: some View {
        VStack {
            
            VStack(spacing: 40) {
                // Login Title
                Text("Kayıt Ol")
                    .font(.title)
                    .bold()
                    .foregroundColor(.primaryA)
                
                Text("Ecoplate'e hoş geldin! Sağlıklı ve sürdürülebilir bir yaşam için buradayız. Sen de hemen aramıza katıl.")
                    .font(.footnote)
                    .foregroundColor(.gray50)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal)
            
            Divider()
                .padding()
            
            TextField("E-posta", text: $email)
                .padding(.leading, 30)  // Sol tarafta simge için yer açıyoruz
                .padding(.vertical, 10)  // Yükseklik için padding
                .background(
                    ZStack(alignment: .leading) {
                        // Kilit simgesini burada ekliyoruz
                        Image(systemName: "envelope.fill")
                            .foregroundColor(.gray)
                            .padding(.leading, -170)  // Simgeyi sola yaslıyoruz
                        // TextField ya da SecureField buraya yerleşiyor
                    }
                )
                .padding(.horizontal)
                .frame(height: 50)  // Yükseklik ayarı
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
            
            SecureField("Şifre", text: $password)
                .padding(.leading, 30)  // Sol tarafta simge için yer açıyoruz
                .padding(.vertical, 10)  // Yükseklik için padding
                .background(
                    ZStack(alignment: .leading) {
                        // Kilit simgesini burada ekliyoruz
                        Image(systemName: "lock.fill")
                            .foregroundColor(.gray)
                            .padding(.leading, -170)  // Simgeyi sola yaslıyoruz
                        // TextField ya da SecureField buraya yerleşiyor
                    }
                )
                .padding(.horizontal)
                .frame(height: 50)  // Yükseklik ayarı
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
            
            
            SecureField("Şifreyi Tekrar Girin", text: $confirmPassword)
                .padding(.leading, 30)  // Sol tarafta simge için yer açıyoruz
                .padding(.vertical, 10)  // Yükseklik için padding
                .background(
                    ZStack(alignment: .leading) {
                        // Kilit simgesini burada ekliyoruz
                        Image(systemName: "lock.fill")
                            .foregroundColor(.gray)
                            .padding(.leading, -170)  // Simgeyi sola yaslıyoruz
                        // TextField ya da SecureField buraya yerleşiyor
                    }
                )
                .padding(.horizontal)
                .frame(height: 50)  // Yükseklik ayarı
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            
            Button(action: {
                signUpUser(email: email, password: password, confirmPassword: confirmPassword)
            }) {
                Text("Kayıt Ol")
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
    }
    
    func signUpUser(email: String, password: String, confirmPassword: String) {
        if password != confirmPassword {
            errorMessage = "Şifreler eşleşmiyor."
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                errorMessage = error.localizedDescription
            } else {
                isUserLoggedIn = true
            }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    @State static var isUserLoggedIn = false  // @State ile isUserLoggedIn için bir değer oluşturuyoruz

    static var previews: some View {
        SignUpView(isUserLoggedIn: $isUserLoggedIn)  // @Binding parametreyi $ ile bağlıyoruz
            .previewLayout(.sizeThatFits)
    }
}


