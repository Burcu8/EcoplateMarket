//
//  PromoCodesView.swift
//  EcoPlate Market
//
//  Created by Burcu Kamilçelebi on 10.04.2025.
//
import SwiftUI

struct PromoCodesView: View {
    @State private var promoCodes: [String] = ["PROMO10", "DISCOUNT20", "SUMMER30"]
    @State private var newPromoCode: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            Text("Promosyon Kodları")
                .font(.largeTitle)
                .bold()
                .padding(.bottom, 10)
            
            // 📋 Listeleme Alanı
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(promoCodes, id: \.self) { code in
                        HStack {
                            Text(code)
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            Button(action: {
                                print("\(code) kodu kullanıldı.")
                                // Burada promosyon kodunu kullanma işlemi yapılabilir (örneğin, Firestore'dan işaretleme/silme)
                                promoCodes.removeAll { $0 == code } // Kod kullanılınca listeden çıkar
                            }) {
                                Text("Kullan")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(.primaryA)
                                    .cornerRadius(10)
                            }
                            
                            Button(action: {
                                // Kod silme işlemi yapılacak
                                promoCodes.removeAll { $0 == code }
                                print("\(code) kodu silindi.")
                            }) {
                                Text("Sil")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(Color.red)
                                    .cornerRadius(10)
                            }
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.03), radius: 1, x: 0, y: 1)
                    }
                }
            }

            Divider().padding(.vertical)

            // ➕ Ekleme Alanı
            VStack(spacing: 16) {
                Text("Yeni Promosyon Kodu Ekle")
                    .font(.title3)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)

                HStack {
                    TextField("Kodu Girin", text: $newPromoCode)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .font(.body)
                        .autocapitalization(.allCharacters)
                        .disableAutocorrection(true)
                        .shadow(color: Color.black.opacity(0.08), radius: 5, x: 0, y: 2)

                    Button(action: {
                        let trimmed = newPromoCode.trimmingCharacters(in: .whitespacesAndNewlines)
                        guard !trimmed.isEmpty else { return }
                        promoCodes.insert(trimmed, at: 0) // Yeni kodu en başa ekle
                        newPromoCode = "" // Kod girdikten sonra alanı temizle
                        print("\(trimmed) kodu eklendi.")
                    }) {
                        Text("Ekle")
                            .font(.body)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(Color.primaryA)
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical, 16)
            .background(Color(.systemGray6))
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)

            Spacer()
        }
        .padding()
        .navigationTitle("Promosyonlarım")
        .background(Color(.systemGroupedBackground))
    }
}

struct PromoCodesView_Previews: PreviewProvider {
    static var previews: some View {
        PromoCodesView()
    }
}




