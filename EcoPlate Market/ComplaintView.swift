//
//  ComplaintView.swift
//  EcoPlate Market
//
//  Created by Burcu Kamilçelebi on 23.05.2025.
//

import SwiftUI

// Şikayet modeli ve durumu
struct Complaint: Identifiable {
    let id = UUID()
    var title: String
    var description: String
    var status: ComplaintStatus
    var date: Date
}

enum ComplaintStatus: String {
    case submitted = "Gönderildi"
    case inReview = "İnceleniyor"
    case resolved = "Çözüldü"
}

// Şikayetler listesi ve detay ekranı tek dosyada

struct ComplaintsView: View {
    @State private var complaints: [Complaint] = [
        Complaint(title: "Bozuk ürün teslim edildi", description: "Sipariş ettiğim süt son kullanma tarihi geçmişti.", status: .submitted, date: Date()),
        Complaint(title: "Teslimat gecikti", description: "Ürün 2 gün geç geldi.", status: .inReview, date: Date().addingTimeInterval(-86400)),
        Complaint(title: "Yanlış ürün gönderildi", description: "Sepette olmayan başka ürün gönderildi.", status: .resolved, date: Date().addingTimeInterval(-172800))
    ]
    
    var body: some View {
        NavigationView {
            List(complaints) { complaint in
                NavigationLink(destination: ComplaintDetailView(complaint: complaint)) {
                    VStack(alignment: .leading) {
                        Text(complaint.title)
                            .font(.headline)
                        Text(complaint.status.rawValue)
                            .font(.subheadline)
                            .foregroundColor(colorForStatus(complaint.status))
                        Text(complaint.date, style: .date)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Şikayetlerim")
        }
    }
    
    func colorForStatus(_ status: ComplaintStatus) -> Color {
        switch status {
        case .submitted: return .orange
        case .inReview: return .blue
        case .resolved: return .primaryA
        }
    }
}

struct ComplaintDetailView: View {
    var complaint: Complaint
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(complaint.title)
                .font(.title2)
                .bold()
            
            Text("Durum: \(complaint.status.rawValue)")
                .foregroundColor(.secondary)
            
            Text("Tarih: \(complaint.date.formatted(date: .abbreviated, time: .omitted))")
                .foregroundColor(.secondary)
            
            Divider()
            
            Text(complaint.description)
                .font(.body)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Şikayet Detayı")
    }
}

struct ComplaintsView_Previews: PreviewProvider {
    static var previews: some View {
        ComplaintsView()
    }
}

