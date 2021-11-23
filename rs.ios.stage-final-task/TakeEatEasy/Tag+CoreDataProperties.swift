//
//  Tag+CoreDataProperties.swift
//  TakeEatEasy
//
//  Created by Nadezhda Zenkova on 09.11.2021.
//
//

import Foundation
import CoreData


extension Tag {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tag> {
        return NSFetchRequest<Tag>(entityName: "Tag")
    }

    @NSManaged public var accuracy: Float
    @NSManaged public var tag: String?
    @NSManaged public var timesUsed: Int64
    @NSManaged public var meal: Meal?

}

extension Tag : Identifiable {

}
