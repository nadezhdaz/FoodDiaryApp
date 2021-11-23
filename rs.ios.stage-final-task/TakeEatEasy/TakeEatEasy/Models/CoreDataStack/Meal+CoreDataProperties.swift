//
//  Meal+CoreDataProperties.swift
//  
//
//  Created by Nadezhda Zenkova on 14.11.2021.
//
//

import Foundation
import CoreData


extension Meal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Meal> {
        return NSFetchRequest<Meal>(entityName: "Meal")
    }

    @NSManaged public var date: Date?
    @NSManaged public var mood: Int32
    @NSManaged public var name: String?
    @NSManaged public var picture: Data?
    @NSManaged public var moodAfter: Int32
    @NSManaged public var tag: String?
    @NSManaged public var tags: NSSet?
    
    var tagsStrings: [String] {
        get {
            let data = Data(tag?.utf8 ?? "".utf8)
            return (try? JSONDecoder().decode([String].self, from: data)) ?? []
        }
        set {
            if let data = try? JSONEncoder().encode(newValue),
               let string = String(data: data, encoding: .utf8) {
                tag = string
            } else {
                tag = ""                
            }
            
        }
    }

}

// MARK: Generated accessors for tags
extension Meal {

    @objc(addTagsObject:)
    @NSManaged public func addToTags(_ value: Tag)

    @objc(removeTagsObject:)
    @NSManaged public func removeFromTags(_ value: Tag)

    @objc(addTags:)
    @NSManaged public func addToTags(_ values: NSSet)

    @objc(removeTags:)
    @NSManaged public func removeFromTags(_ values: NSSet)

}
