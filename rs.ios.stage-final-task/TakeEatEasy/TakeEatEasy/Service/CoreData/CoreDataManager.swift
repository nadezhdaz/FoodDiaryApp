//
//  CoreDataManager.swift
//  TakeEatEasy
//
//  Created by Nadezhda Zenkova on 10.11.2021.
//

import UIKit
import CoreData

protocol CoreDataServiceType {
    
    func fetchRecentMeal() -> [MealModel]?
    
    func fetchMeals() -> [MealModel]?
    func fetchTags(meal: MealModel) -> [TagModel]
    
    func fetchPopularTags(amount: Int) -> [TagModel]?
    func fetchMealStatistics() -> [MealModel]?
    //func fetchPopularTagsStrings(amount: Int) -> [String]?
    
    func addNewMeal(mealModel: MealModel)
    func addTag(tagModel: TagModel, in mealModel: MealModel)
    
    func changeMeal(mealModel: MealModel)
    
    func meal(with id: NSManagedObjectID) -> MealModel?
    
    func deleteMeal(with id: NSManagedObjectID)
    func deleteTag(tagModel: TagModel, in mealModel: MealModel)
    
    func saveContext()
}


class CoreDataService: NSObject, CoreDataServiceType {
    let managedObjectContext: NSManagedObjectContext
    let persistentContainer: NSPersistentContainer
    
    func fetchRecentMeal() -> [MealModel]? {
        let request: NSFetchRequest<Meal> = Meal.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        request.fetchLimit = 1
        let meals: [Meal]? = try? managedObjectContext.fetch(request)
        return meals?.map{$0.mealModel}
    }
    
    func fetchMeals() -> [MealModel]? {
        //let meals: [Meal]? = try? managedObjectContext.fetch(Meal.fetchRequest())
        let request: NSFetchRequest<Meal> = Meal.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        let meals: [Meal]? = try? managedObjectContext.fetch(request)
        return meals?.map{$0.mealModel}
    }
    
    func fetchTags(meal: MealModel) -> [TagModel] {
        let sortDescriptor = NSSortDescriptor(key: "tag", ascending: true)
        guard let id = meal.id, let meal = managedObjectContext.object(with: id) as? Meal, let tags = meal.tags?.sortedArray(using: [sortDescriptor]) as? [Tag] else { return [] }
        return tags.map({$0.tagModel})//.sorted(by: {$0.tag > $1.tag})
    }
    
    func fetchPopularTags(amount: Int) -> [TagModel]? {
        let tags: [Tag]? = try? managedObjectContext.fetch(Tag.fetchRequest())
        let sortedTags = tags?.map{$0.tagModel}.sorted(by: {$0.tag.count > $1.tag.count })
        let firstThreeTags = sortedTags?.limit(amount)
        return firstThreeTags
    }
    
    /*func fetchPopularTagsStrings(amount: Int) -> [String]? {
        let request: NSFetchRequest<Meal> = Meal.fetchRequest()
        request.predicate = NSPredicate(format: "tag != nil")
        let meals: [Meal]? = try? managedObjectContext.fetch(request)
        let models = meals?.map{$0.mealModel}
        let tags = models.map { $0. }
        return tags
        
        let tags: [Tag]? = try? managedObjectContext.fetch(Tag.fetchRequest())
        let sortedTags = tags?.map{$0.tagModel}.sorted(by: {$0.tag.count > $1.tag.count })
        let firstThreeTags = sortedTags?.limit(amount)
        return firstThreeTags
    }*/
    
    func fetchMealStatistics() -> [MealModel]? {
        let request: NSFetchRequest<Meal> = Meal.fetchRequest()
        request.predicate = NSPredicate(format: "mood.rawValue != nil && moodAfter.rawValue != nil")
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        let meals: [Meal]? = try? managedObjectContext.fetch(request)
        return meals?.map{$0.mealModel}
    }
    
    func addNewMeal(mealModel: MealModel) {
        let meal = Meal(context: managedObjectContext)
        meal.name = mealModel.name
        meal.date = mealModel.date
        meal.picture = mealModel.picture.toData
        meal.mood = mealModel.mood?.rawValue ?? 0
        meal.moodAfter = mealModel.moodAfter?.rawValue ?? 0
        meal.tags = NSSet(array: [])
        meal.tagsStrings = mealModel.tagStrings ?? []
        
        for tag in mealModel.tagStrings ?? [] {
            let newTag = Tag(context: managedObjectContext)
            newTag.tag = tag
            //newTag.accuracy = tag.accuracy ?? 0.5
            newTag.meal = meal
        }
        
        
        saveContext()
    }
    
    func addTag(tagModel: TagModel, in meal: MealModel) {
        guard let id = meal.id, let meal = managedObjectContext.object(with: id) as? Meal else { return }
        let tag = Tag(context: managedObjectContext)
        tag.meal = meal
        tag.tag = tagModel.tag
        meal.addToTags(tag)
        saveContext()
    }
    
    func changeMeal(mealModel: MealModel) {
        guard let id = mealModel.id, let meal = managedObjectContext.object(with: id) as? Meal else { return }
        meal.name = mealModel.name
        meal.date = mealModel.date
        meal.picture = mealModel.picture.toData
        meal.mood = mealModel.mood?.rawValue ?? 3
        meal.moodAfter = mealModel.moodAfter?.rawValue ?? 3
        meal.tags = NSSet(array: mealModel.tags ?? [])
        saveContext()
    }
    
    func meal(with id: NSManagedObjectID) -> MealModel? {
        (managedObjectContext.object(with: id) as? Meal)?.mealModel
    }
    
    func deleteMeal(with id: NSManagedObjectID) {
        managedObjectContext.delete(managedObjectContext.object(with: id))
        saveContext()
    }
    
    func deleteTag(tagModel: TagModel, in mealModel: MealModel) {
        guard let id = tagModel.id, let tag = managedObjectContext.object(with: id) as? Tag, let mealId = mealModel.id, let meal = managedObjectContext.object(with: mealId) as? Meal else {return}
        meal.removeFromTags(tag)
        saveContext()
    }
    
    init(container: String) {
        persistentContainer = NSPersistentContainer(name: container)
        persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        managedObjectContext = persistentContainer.newBackgroundContext()
    }
    
    func saveContext() {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                let contextError = error as NSError
                fatalError("Unresolved error \(contextError), \(contextError.userInfo)")
            }
        }
    }
    
}
