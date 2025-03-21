//
//  AccountView.swift
//  EcoPlate Market
//
//  Created by Burcu Kamilçelebi on 18.03.2025.
//

import SwiftUI

struct AccountView: View {
    @Binding var isUserLoggedIn: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 8) {
                // Profil Fotoğrafı
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 70, height: 70)
                    .foregroundColor(.gray)
                
                // Profil Bilgileri
                VStack(alignment: .leading, spacing: 5) {
                    Text("Alpur Market")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("alpugrdal@gmail.com")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Text("+0212 216 5115")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.leading, 10) // Sol padding eklenebilir
            }
            .frame(maxWidth: .infinity, alignment: .leading) // Sağda boşluk bırakmamak için hizalama ekledik
            .padding(.top, 20)
            
            Divider()
            
            // Hesap İlgili Diğer Alanlar
            VStack(spacing: 20) {
                AccountOptionView(title: "📦 Geçmiş Siparişler")
                Divider()
                AccountOptionView(title: "🆔 Satıcı Kimlik Bilgileri")
                Divider()
                AccountOptionView(title: "🏠 Adres Bilgileri")
                Divider()
                AccountOptionView(title: "🏦 Banka Hesabıma Transfer")
                Divider()
                AccountOptionView(title: "🎁 Promosyon Kodları")
                Divider()
                AccountOptionView(title: "🔔 Bildirimler")
                Divider()
                AccountOptionView(title: "❓ Yardım")
                Divider()
                AccountOptionView(title: "📝 Şikayetlerim")
                Divider()
            }
            .padding(.top, 8)
            
            // Çıkış Yap Butonu
            NavigationLink(destination: LoginView(isUserLoggedIn: $isUserLoggedIn)) {
                Text("Çıkış Yap")
                    .font(.headline)
                    .foregroundColor(.green)
                    .frame(maxWidth: .infinity, minHeight: 30)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(18)
                    .shadow(radius: 5)
            }
            .padding(.top, 15)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Hesap")
    }
    
}

struct AccountOptionView: View {
    var title: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.blue)
        }
        .padding(.horizontal)
        .onTapGesture {
            // İlgili sayfaya yönlendirme kodu buraya gelecek
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView(isUserLoggedIn: .constant(true))
    }
}

