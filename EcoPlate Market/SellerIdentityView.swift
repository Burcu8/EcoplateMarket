//
//  SellerIdentityView.swift
//  EcoPlate Market
//
//  Created by Burcu Kamilçelebi on 10.04.2025.
//

import SwiftUI
import FirebaseAuth

struct SellerIdentityView: View {
    @ObservedObject var viewModel: MarketViewModel
    @State private var taxNumber: String = "TR1234567890"
    @State private var isEditing: Bool = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                HStack {
                    Text("Satıcı Kimlik Bilgileri")
                        .font(.title)
                        .fontWeight(.bold)
                    Spacer()
                    Button(isEditing ? "Kaydet" : "Düzenle") {
                        isEditing.toggle()
                    }
                    .font(.headline)
                }
                .padding(.bottom, 10)

                if let market = viewModel.market {
                    Group {
                        EditableInfoField(title: "👤 Ad Soyad", text: binding(for: \.name), isEditing: isEditing)
                        EditableInfoField(title: "🆔 Satıcı Kimlik No", text: binding(for: \.id), isEditing: isEditing)
                        EditableInfoField(title: "💼 Vergi Numarası", text: $taxNumber, isEditing: isEditing)
                        EditableInfoField(title: "🏢 İşletme Adı", text: binding(for: \.name), isEditing: isEditing)
                        EditableInfoField(title: "📞 Telefon Numarası", text: binding(for: \.phone), isEditing: isEditing)
                        EditableInfoField(title: "🏠 Adres", text: binding(for: \.address), isEditing: isEditing)
                    }
                } else {
                    Text("Veriler yükleniyor...")
                        .foregroundColor(.gray)
                }
            }
            .padding()
        }
        .onAppear {
            // Sayfa yüklendiğinde çalışacak işlemler
            if let currentUserId = Auth.auth().currentUser?.uid {
                viewModel.loadMarket(marketId: currentUserId)
            } else {
                print("Kullanıcı girişi yapılmamış.")
            }
        }
        .navigationTitle("Satıcı Bilgileri")
    }

    // Opsiyonel market için binding üreten yardımcı fonksiyon
    private func binding(for keyPath: WritableKeyPath<Market, String>) -> Binding<String> {
        Binding(
            get: { viewModel.market?[keyPath: keyPath] ?? "" },
            set: { newValue in
                if viewModel.market != nil {
                    viewModel.market![keyPath: keyPath] = newValue
                }
            }
        )
    }
}


struct EditableInfoField: View {
    let title: String
    @Binding var text: String
    var isEditing: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.title3)
                .foregroundColor(.secondary)
            
            if isEditing {
                TextField("", text: $text)
                    .font(.title3)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            } else {
                Text(text)
                    .font(.title3)
                    .foregroundColor(.primary)
            }
        }
    }
}


#Preview {
    let sampleMarket = Market(
        id: "987654321",
        name: "Alpur Market",
        address: "İstanbul, Türkiye",
        logo_url: "",
        email: "alpur@example.com",
        phone: "+0212 216 5115"
    )
    let viewModel = MarketViewModel()
    viewModel.market = sampleMarket
    
    return SellerIdentityView(viewModel: viewModel)
}


