//
//  BankAccountView.swift
//  EcoPlate Market
//
//  Created by Burcu Kamilçelebi on 10.04.2025.
//

import SwiftUI

struct BankAccountView: View {
    @State private var bankName: String = "Ziraat Bankası"
    @State private var accountNumber: String = "1234567890123456"
    @State private var iban: String = "TR3301234567890123456789012"
    @State private var accountType: String = "Vadesiz Hesap"
    @State private var balance: String = "5000 ₺"

    @State private var isEditing = false

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                HStack {
                    Text("Banka Hesap Bilgileri")
                        .font(.title)
                        .fontWeight(.bold)
                    Spacer()
                    Button(isEditing ? "Kaydet" : "Düzenle") {
                        isEditing.toggle()
                    }
                }

                BankInfoRow(icon: "🏦", title: "Banka Adı", value: $bankName, isEditing: isEditing, isEditable: true)
                BankInfoRow(icon: "💳", title: "Hesap Numarası", value: $accountNumber, isEditing: isEditing, isEditable: true)
                BankInfoRow(icon: "🌍", title: "IBAN Numarası", value: $iban, isEditing: isEditing, isEditable: true)
                BankInfoRow(icon: "📂", title: "Hesap Türü", value: $accountType, isEditing: isEditing, isEditable: true)
                BankInfoRow(icon: "💰", title: "Bakiye", value: $balance, isEditing: isEditing, isEditable: false) // burada düzenlenemez

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Banka Hesap Bilgileri")
    }
}

struct BankInfoRow: View {
    var icon: String
    var title: String
    @Binding var value: String
    var isEditing: Bool
    var isEditable: Bool  // yeni parametre

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("\(icon) \(title)")
                .font(.subheadline)
                .foregroundColor(.gray)

            if isEditing && isEditable {
                TextField("\(title)", text: $value)
                    .padding(14)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
            } else {
                Text(value)
                    .font(.body)
                    .padding(17)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
            }
        }
        .padding(.horizontal)
    }
}



struct BankAccountView_Previews: PreviewProvider {
    static var previews: some View {
        BankAccountView()
    }
}

