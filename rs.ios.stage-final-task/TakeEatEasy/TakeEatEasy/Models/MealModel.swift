//
//  MealModel.swift
//  TakeEatEasy
//
//  Created by Nadezhda Zenkova on 09.11.2021.
//

import UIKit
import CoreData

struct MealModel {
    var id: NSManagedObjectID?
    var name: String?
    var date: Date?
    var picture: UIImage?
    var tags: [TagModel]?
    var tagStrings: [String]?
    var mood: MoodModel?
    var moodAfter: MoodModel?
    
    public func tagsList() -> String? {
        guard let tags = tagStrings else { return nil }
        return tags.joined(separator:", ")
    }
}

extension Meal {
    
    var mealModel: MealModel {
        MealModel(id: objectID, name: name, date: date, picture: UIImage(data: picture ?? <#default value#>), tagStrings: tagsStrings, mood: MoodModel(rawValue: mood) ?? MoodModel(rawValue: 3), moodAfter: MoodModel(rawValue: moodAfter) ?? MoodModel(rawValue: 3))
    }
    
}
