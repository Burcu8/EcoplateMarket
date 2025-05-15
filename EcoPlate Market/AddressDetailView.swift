//
//  AddressDetailView.swift
//  EcoPlate Market
//
//  Created by Burcu Kamilçelebi on 13.04.2025.
//

import SwiftUI

struct AddressDetailView: View {
    @ObservedObject var viewModel: MarketViewModel
    @State private var isEditing = false
    @State private var name: String = ""
    @State private var phone: String = ""
    @State private var address: String = ""

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Adres Bilgileri")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
                Button(isEditing ? "Kaydet" : "Düzenle") {
                    if isEditing {
                        // Kaydetme işlemi yapılabilir: viewModel üstünden Firestore'a güncelleme gibi
                        // Örn: viewModel.updateMarket(name: name, phone: phone, address: address)
                    } else {
                        if let market = viewModel.market {
                            name = market.name
                            phone = market.phone
                            address = market.address
                        }
                    }
                    isEditing.toggle()
                }
            }

            if isEditing {
                EditableRow(title: "Ad Soyad", text: $name, icon: "person.fill")
                EditableRow(title: "Telefon", text: $phone, icon: "phone.fill")
                EditableRow(title: "Adres", text: $address, icon: "mappin.and.ellipse")
            } else {
                if let market = viewModel.market {
                    AddressInfoRow(title: "Ad Soyad", value: market.name, icon: "person.fill")
                    AddressInfoRow(title: "Telefon", value: market.phone, icon: "phone.fill")
                    AddressInfoRow(title: "Adres", value: market.address, icon: "mappin.and.ellipse")
                } else {
                    Text("Veriler yüklenemedi.")
                        .foregroundColor(.gray)
                }
            }

            Spacer()
        }
        .padding()
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Adres Bilgileri")
    }
}


struct AddressInfoRow: View {
    var title: String
    var value: String
    var icon: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .font(.title3)
                .frame(width: 30, height: 30)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.gray)
                Text(value)
                    .font(.body)
                    .foregroundColor(.black)
            }

            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(14)
        .shadow(color: Color.black.opacity(0.03), radius: 4, x: 0, y: 2)
    }
}

struct EditableRow: View {
    var title: String
    @Binding var text: String
    var icon: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .font(.title3)
                .frame(width: 30, height: 30)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.gray)
                TextField(title, text: $text)
                    .font(.body)
                    .foregroundColor(.black)
                    .textFieldStyle(PlainTextFieldStyle())
            }

            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(14)
        .shadow(color: Color.black.opacity(0.03), radius: 4, x: 0, y: 2)
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
    
    return AddressDetailView(viewModel: viewModel)
}
