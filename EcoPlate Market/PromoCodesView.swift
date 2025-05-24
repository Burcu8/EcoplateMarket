//
//  PromoCodesView.swift
//  EcoPlate Market
//
//  Created by Burcu Kamilçelebi on 10.04.2025.
//
import SwiftUI
import FirebaseFirestore
import FirebaseAuth

extension View {
    func hideKeyboard2() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct PromoCode: Identifiable {
    var id: String
    var promotionName: String
    var promotionPercentage: Int
}

struct PromoCodesView: View {
    @State private var promoCodes: [PromoCode] = []
    @State private var newPromoCode: String = ""
    @State private var newPercentage: String = ""

    private var marketId: String {
        Auth.auth().currentUser?.uid ?? ""
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            Text("Promosyon Kodları")
                .font(.largeTitle)
                .bold()
                .padding(.bottom, 10)
            
            // 📋 Listeleme
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(promoCodes) { code in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(code.promotionName)
                                    .font(.headline)
                                Text("%\(code.promotionPercentage) indirim")
                                    .font(.subheadline)
                            }

                            Spacer()

                            Button(action: {
                                deletePromoCode(id: code.id)
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

                TextField("Kod Adı (örneğin: ecoplate)", text: $newPromoCode)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)

                TextField("İndirim Oranı (%)", text: $newPercentage)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .keyboardType(.numberPad)

                Button(action: addPromoCode) {
                    Text("Ekle")
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(Color.primaryA) // İsteğe göre Color.primaryA
                        .cornerRadius(10)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(15)

            Spacer()
        }
        .padding()
        .onTapGesture {
            self.hideKeyboard2()
        }
        .onAppear {
            if !marketId.isEmpty {
                fetchPromoCodes()
            }
        }
    }

    // 🔄 Firestore’dan verileri çek (Yeni root-level yol)
    func fetchPromoCodes() {
        let db = Firestore.firestore()
        db.collection("promotion_codes")
            .whereField("market_id", isEqualTo: marketId)
            .getDocuments { snapshot, error in
                if let documents = snapshot?.documents {
                    self.promoCodes = documents.compactMap { doc in
                        let data = doc.data()
                        let name = data["promotion_name"] as? String ?? ""
                        let percentage = data["promotion_percentage"] as? Int ?? 0
                        return PromoCode(id: doc.documentID, promotionName: name, promotionPercentage: percentage)
                    }
                }
            }
    }

    // ➕ Promosyon kodu ekle (Yeni root-level yol)
    func addPromoCode() {
        hideKeyboard2()  // Klavyeyi kapat
        guard !newPromoCode.isEmpty,
              let percentage = Int(newPercentage),
              !marketId.isEmpty else { return }

        let db = Firestore.firestore()
        let newCode = [
            "promotion_name": newPromoCode,
            "promotion_percentage": percentage,
            "market_id": marketId
        ] as [String : Any]

        db.collection("promotion_codes").addDocument(data: newCode) { error in
            if error == nil {
                newPromoCode = ""
                newPercentage = ""
                fetchPromoCodes()
            }
        }
    }

    // 🗑️ Promosyon kodu sil (Yeni root-level yol)
    func deletePromoCode(id: String) {
        let db = Firestore.firestore()
        db.collection("promotion_codes").document(id).delete { error in
            if error == nil {
                fetchPromoCodes()
            }
        }
    }
}

struct PromoCodesView_Previews: PreviewProvider {
    static var previews: some View {
        PromoCodesView()
    }
}
