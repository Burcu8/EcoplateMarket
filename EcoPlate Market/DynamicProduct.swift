//
//  DynamicProduct.swift
//  EcoPlate Market
//
//  Created by Burcu Kamilçelebi on 11.04.2025.
//

import Foundation
import FirebaseFirestore

class DynamicProduct: ObservableObject, Identifiable {
    //@DocumentID var id: String?
    @Published var id: String?
    @Published var name: String
    @Published var description: String
    @Published var discounted_price: Double
    @Published var price: Double
    @Published var grammage: String
    @Published var expiry_date: Date
    @Published var image_url: String
    @Published var category: String

    init(id: String, name: String, description: String, price: Double, discounted_price: Double, grammage: String, expiry_date: Date, image_url: String, category: String) {
        self.id = id
        self.name = name
        self.description = description
        self.discounted_price = discounted_price
        self.price = price
        self.grammage = grammage
        self.expiry_date = expiry_date
        self.image_url = image_url
        self.category = category
    }
}







//import Foundation

//struct DynamicProduct: Identifiable, Codable{
//    var id: String
//    var name: String
//    var description: String
//    var normalPrice: String
//    var oldPrice: String
//    var weight: String
//    var expirationDate: String
//    var imageBase64: String
//    var createdAt: Date
//}
