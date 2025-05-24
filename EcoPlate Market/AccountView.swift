//
//  AccountView.swift
//  EcoPlate Market
//
//  Created by Burcu Kamilçelebi on 18.03.2025.
//

import SwiftUI
import FirebaseAuth

struct AccountView: View {
    @Binding var isUserLoggedIn: Bool
    @StateObject private var viewModel = MarketViewModel()
    let currentMarketId: String
    
    var body: some View {
            NavigationView { // NavigationView ekledik
                VStack(spacing: 20) {
                    HStack(spacing: 8) {
                        // Profil Fotoğrafı
                        if let logoURL = viewModel.market?.logo_url, let url = URL(string: logoURL) {
                            AsyncImage(url: url) { image in
                                image.resizable()
                            } placeholder: {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .foregroundColor(.gray)
                            }
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                        } else {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.gray)
                        }

                        
                        // Profil Bilgileri
                        VStack(alignment: .leading, spacing: 5) {
                            Text(viewModel.market?.name.isEmpty == false ? viewModel.market!.name : "Bilinmeyen Market")
                                .font(.headline)
                                .foregroundColor(.gray)
                            
                            Text(viewModel.market?.email.isEmpty == false ? viewModel.market!.email : "test@gmail.com")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            
                            Text(viewModel.market?.phone.isEmpty == false ? viewModel.market!.phone : "+0212 212 5313")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding(.leading, 10)

                    }
                    .frame(maxWidth: .infinity, alignment: .leading) // Sağda boşluk bırakmamak için hizalama ekledik
                    .padding(.top, 20)
                    
                    Divider()
                    
                    ScrollView {
                                        VStack(spacing: 20) {
                                            NavigationLink(destination: SellerDashboardView()) {
                                                AccountOptionView(title: "📊 Satıcı Paneli")
                                            }
                                            Divider()
                                            NavigationLink(destination: OrderListView(currentMarketId: currentMarketId)) {
                                                AccountOptionView(title: "📦 Siparişler")
                                            }
                                            Divider()
                                            NavigationLink(destination: SellerIdentityView(viewModel: viewModel)) {
                                                AccountOptionView(title: "🆔 Satıcı Kimlik Bilgileri")
                                            }
                                            Divider()
                                            NavigationLink(destination: AddressDetailView(viewModel: viewModel)) {
                                                AccountOptionView(title: "🏠 Adres Bilgileri")
                                            }
                                            Divider()
                                            NavigationLink(destination: BankAccountView()) {
                                                AccountOptionView(title: "🏦 Banka Hesabıma Transfer")
                                            }
                                            Divider()
                                            NavigationLink(destination: PromoCodesView()) {
                                                AccountOptionView(title: "🎁 Promosyon Kodları")
                                            }
                                            Divider()
                                            NavigationLink(destination: NotificationsView()) {
                                                AccountOptionView(title: "🔔 Bildirimler")
                                            }
                                            Divider()
                                            NavigationLink(destination: HelpView()) {
                                                AccountOptionView(title: "❓ Yardım")
                                            }
                                            Divider()
                                            NavigationLink(destination: ComplaintsView()) {
                                                AccountOptionView(title: "📝 Şikayetlerim")
                                            }
                                            Divider()
                                        }
                                        .foregroundColor(.black)
                                        .padding(.top, 8)
                                    }
                    
                    Button(action: {
                        do {
                            try Auth.auth().signOut()  // Firebase'den çıkış yap
                            isUserLoggedIn = false     // Login ekranına yönlendir
                            print("Çıkış yapıldı, isUserLoggedIn: \(isUserLoggedIn)") // Debug için
                        } catch {
                            print("Çıkış yapılamadı: \(error.localizedDescription)")
                        }
                    }) {
                        Text("Çıkış Yap")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, minHeight: 30)
                            .padding()
                            .background(Color.primaryA)
                            .cornerRadius(18)
                    }
                    .padding(.top, 15)
                    
                    Spacer()
                }
                .padding()
                .onAppear {
                    // Sayfa yüklendiğinde çalışacak işlemler
                    if let currentUserId = Auth.auth().currentUser?.uid {
                        viewModel.loadMarket(marketId: currentUserId)
                    } else {
                        print("Kullanıcı girişi yapılmamış.")
                    }
                }
            }
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
    }
}


struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView(isUserLoggedIn: .constant(true), currentMarketId: "wiOiNpZKdLSrLcZG2U6tAG6P1gi2")
    }
}
