//
//  TagsResultsModel.swift
//  TakeEatEasy
//
//  Created by Nadezhda Zenkova on 10.11.2021.
//

import Foundation

struct TagResultsModel: Codable {
    var keywords: [TagModel]
    var status: String
    
    enum CodingKeys: String, CodingKey {
        case keywords, status
    }
}

struct StatusModel: Codable {
    var status: String
    
    enum CodingKeys: String, CodingKey {
        case status
    }
}


