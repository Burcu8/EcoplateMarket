//
//  Market.swift
//  EcoPlate Market
//
//  Created by Burcu Kamilçelebi on 12.05.2025.
//

import Foundation
import FirebaseFirestore


struct Market: Identifiable, Codable {
    var id: String
    var name: String
    var address: String
    var logo_url: String
    var email: String
    var phone: String
}

