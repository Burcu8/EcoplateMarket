//
//  NotificationsView.swift
//  EcoPlate Market
//
//  Created by Burcu Kamilçelebi on 13.04.2025.
//

import SwiftUI

struct NotificationsView: View {
    // Örnek veriler
    let notifications = [
        NotificationItem(title: "Yeni Sipariş Alındı", message: "Sipariş #54321 başarıyla alındı.", date: "13 Nisan 2025", icon: "cart.fill"),
        NotificationItem(title: "Ürün Yayınlandı", message: "Elma (1kg) yayına alındı.", date: "12 Nisan 2025", icon: "checkmark.seal.fill"),
        NotificationItem(title: "Yeni Yorum", message: "Bir müşteri ürününüze yorum yaptı.", date: "10 Nisan 2025", icon: "message.fill")
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Bildirimler")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                ForEach(notifications, id: \.self) { notification in
                    NotificationCardView(notification: notification)
                }
            }
            .padding()
        }
        .navigationTitle("Bildirimler")
        .background(Color(.systemGroupedBackground))
    }
}

struct NotificationItem: Hashable {
    var title: String
    var message: String
    var date: String
    var icon: String
}

struct NotificationCardView: View {
    var notification: NotificationItem
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: notification.icon)
                .font(.title2)
                .foregroundColor(.primaryA)
                .frame(width: 40, height: 40)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(notification.title)
                    .font(.headline)
                
                Text(notification.message)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Text(notification.date)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.03), radius: 3, x: 0, y: 2)
    }
}


#Preview {
    NotificationsView()
}
