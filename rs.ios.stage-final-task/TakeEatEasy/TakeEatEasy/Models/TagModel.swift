//
//  TagModel.swift
//  TakeEatEasy
//
//  Created by Nadezhda Zenkova on 09.11.2021.
//

import Foundation
import CoreData

struct TagModel: Codable {
    var id: NSManagedObjectID?
    var tag: String
    var accuracy: Float?
    var timesUsed: Int64?
    
    enum CodingKeys: String, CodingKey {
        case tag = "keyword"
        case accuracy = "score"
        case timesUsed
    }
}

extension Tag {
    
    var tagModel: TagModel {
        TagModel(tag: tag!, accuracy: accuracy, timesUsed: timesUsed)
    }
}
      
