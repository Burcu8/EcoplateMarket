//
//  MarketViewModel.swift
//  EcoPlate Market
//
//  Created by Burcu Kamilçelebi on 12.05.2025.
//

import Foundation
import FirebaseFirestore
//import FirebaseFirestoreSwift



class MarketViewModel: ObservableObject {
    @Published var market: Market?

    func loadMarket(marketId: String) {
        MarketService.fetchMarketInfo(for: marketId) { [weak self] fetchedMarket in
            DispatchQueue.main.async {
                self?.market = fetchedMarket
            }
        }
    }
}
