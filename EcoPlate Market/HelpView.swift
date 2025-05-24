//
//  HelpView.swift
//  EcoPlate Market
//
//  Created by Burcu Kamilçelebi on 23.05.2025.
//

import SwiftUI

struct HelpView: View {
    // Kullanıcı destek mesajı için state
    @State private var supportMessage: String = ""
    @State private var showAlert = false

    // Sıkça Sorulan Sorular örneği (statik)
    let faqs = [
        ("Ecoplate Market nedir ve nasıl çalışır?", "Ecoplate Market, son kullanma tarihi yaklaşan ürünlerin indirimli fiyatlarla satıldığı bir platformdur."),
        ("Şifremi unuttum, ne yapmalıyım?", "Şifremi unuttum linkine tıklayıp e-posta adresinizi giriniz."),
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Sıkça Sorulan Sorular")
                    .font(.title2)
                    .fontWeight(.bold)
                
                ForEach(faqs, id: \.0) { faq in
                    VStack(alignment: .leading, spacing: 5) {
                        Text(faq.0)
                            .fontWeight(.semibold)
                        Text(faq.1)
                            .foregroundColor(.gray)
                    }
                    .padding(.bottom, 10)
                }
                
                Divider()
                    .padding(.vertical)
                
                Text("Destek Mesajı Gönder")
                    .font(.title2)
                    .fontWeight(.bold)
                
                TextEditor(text: $supportMessage)
                    .frame(height: 150)
                    .padding(8)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                
                Button(action: {
                    if supportMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        // Boş mesaj gönderilmesin
                        showAlert = true
                    } else {
                        // Burada mesajı backend’e veya e-posta sistemine gönderme işlemi yapılabilir
                        supportMessage = ""  // Mesaj kutusunu temizle
                    }
                }) {
                    Text("Gönder")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.primaryA)
                        .cornerRadius(10)
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Uyarı"), message: Text("Lütfen mesajınızı yazınız."), dismissButton: .default(Text("Tamam")))
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Yardım")
    }
}


#Preview {
    HelpView()
}
