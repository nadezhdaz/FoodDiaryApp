//
//  FoodPlaceholderModel.swift
//  TakeEatEasy
//
//  Created by Nadezhda Zenkova on 11.11.2021.
//

import Foundation

struct FoodPlaceholderModel: Codable {
    var imageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case imageUrl = "image"
    }
}
