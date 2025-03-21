//
//  LoginView.swift
//  EcoPlate Market
//
//  Created by Burcu Kamilçelebi on 17.03.2025.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?
    @Binding var isUserLoggedIn: Bool  // Parent'tan gelen binding değişken

    var body: some View {
        NavigationStack {
            VStack {
                VStack(spacing: 16) {
                    // Login Title
                    Text("Giriş Yap")
                        .font(.title)
                        .bold()
                        .foregroundColor(.primaryA)
                    
                    Text("Ecoplate'e hoş geldin! Sağlıklı ve sürdürülebilir bir yaşam için buradayız. Sen de hemen giriş yap.")
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
                

                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                
                HStack {
                        Spacer()  // Metni sağa yaslamak için Spacer() ekliyoruz.
                        Text("Şifrenizi mi unuttunuz?")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 10)  // Üstten biraz boşluk ekliyoruz
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
                

                HStack {
                        Text("Hesabınız yok mu?")  // Normal yazı
                            .font(.body)
                            .foregroundColor(.gray)
                        
                        NavigationLink(destination: SignUpView(isUserLoggedIn: $isUserLoggedIn)) {
                            Text("Kayıt Ol")  // Yeşil renkli link
                                .font(.body)
                                .foregroundColor(.primaryA)  // Yeşil renk
                        }
                    }
                    .padding(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
        }
    }

    func loginUser(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                switch AuthErrorCode(rawValue: error._code) {
                case .wrongPassword:
                    errorMessage = "Şifre yanlış. Lütfen tekrar deneyin."
                case .userNotFound:
                    errorMessage = "Böyle bir kullanıcı bulunamadı. Lütfen kayıt olun."
                case .invalidEmail:
                    errorMessage = "Geçersiz e-posta adresi."
                default:
                    errorMessage = "Giriş yapılamadı. Lütfen tekrar deneyin."
                }
            } else {
                isUserLoggedIn = true  // Başarıyla giriş yaptıysa, HomeView'a yönlendir
            }
        }
    }
    


}

struct LoginView_Previews: PreviewProvider {
    @State static var isUserLoggedIn = false  // @State ile isUserLoggedIn için bir değer oluşturuyoruz

    static var previews: some View {
        LoginView(isUserLoggedIn: $isUserLoggedIn)  // @Binding parametreyi $ ile bağlıyoruz
            .previewLayout(.sizeThatFits)
    }
}

