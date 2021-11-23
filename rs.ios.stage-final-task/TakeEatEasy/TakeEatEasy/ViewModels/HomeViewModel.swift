//
//  HomeViewModel.swift
//  TakeEatEasy
//
//  Created by Nadezhda Zenkova on 09.11.2021.
//

import UIKit

enum CellType {
    case meal
    case placeholder
}

protocol HomeViewModelType {
    
    // Data Source
    
    var shouldShowMealPlaceholder: Bool { get }
    
    var shouldShowTagsPlaceholder: Bool { get }
    
    var cellType: CellType { get }
    
    func numberOfItems() -> Int
    
    func itemForMeal(row: Int) -> MealModel?
    
    func itemForPlaceholder(row: Int) -> [String]
    
    // Events
    func start()
    
    func didSelectRow(_ row: Int, from controller: UIViewController)
    
    var viewDelegate: HomeViewModelViewDelegate? { get set }
    
    var dataWasReceived: (() -> Void)? { get set }
    
    func getTags() -> [String]
    
    func getFoodPlaceholder(completion: @escaping (String) -> Void)
    
}

protocol HomeViewModelCoordinatorDelegate: class {
    
    func goToMealEditor(meal: MealModel, from controller: UIViewController)
    
}

protocol HomeViewModelViewDelegate: class {
    
    func updateScreen()
    
    func showTagsPlaceholder()
    
    func showMealPlaceholder()
    
    func setTags()
    
    func showError(_ message: String)
    
    //func updateState(_ state: ViewControllerState)
    
}

class HomeViewModel {
    
    // MARK: - Delegates
    weak var coordinatorDelegate: HomeViewModelCoordinatorDelegate?
    
    var viewDelegate: HomeViewModelViewDelegate?
    
    var dataWasReceived: (() -> Void)?
    
    // MARK: - Properties
    
    fileprivate let service: FoodPlaceholderApiService
    fileprivate let datasource: CoreDataServiceType
    
    fileprivate var recentMeal: [MealModel]?
    
    fileprivate var popularTags: [TagModel]?
    
    fileprivate var placeholderUrls: [String] = []
    
    fileprivate var isAnyMealLogged = false
    
    fileprivate var isAnyTagAdded = false
    
    // MARK: - Init
    init(service: FoodPlaceholderApiService, datasource: CoreDataServiceType) {
        self.service = service
        self.datasource = datasource
    }
    
    func start() {
        getPopularTags()
        getRecentMeal()
    }
    
    // MARK: - Core Data
    
    func getRecentMeal() {
        if let meals = datasource.fetchRecentMeal(), !(meals.isEmpty) {
            self.recentMeal = meals
            self.isAnyMealLogged = true
            viewDelegate?.updateScreen()
        } else {
            self.isAnyMealLogged = false
        }
    }
    
    // MARK: - Network
    
    func getPopularTags() {
        if let tags = datasource.fetchPopularTags(amount: 3), !(tags.isEmpty) {
            self.popularTags = tags
            self.isAnyTagAdded = true
            viewDelegate?.setTags()
        } else {
            self.isAnyTagAdded = false
            viewDelegate?.showTagsPlaceholder()
        }
        
    }
    
    func getFoodPlaceholder(completion: @escaping (String) -> Void) {
        service.getFoodImage(completion: { [weak self] result, error in
            DispatchQueue.main.async {
            if let placeholder = result {
                    completion(placeholder.imageUrl)
            } else if let error = error {
                self?.viewDelegate?.showError(error.localizedDescription)
            }
            }
        })
        
    }
    
}

extension HomeViewModel: HomeViewModelType {
    var cellType: CellType {
        return isAnyMealLogged ? .meal : .placeholder
    }
    
    
    func getTags() -> [String] {
        guard let tags = popularTags else { return [] }
        var tagsText: [String] = []
        for tag in tags {
            tagsText.append(tag.tag)
        }
        return tagsText
    }
    
    
    // MARK: - Data Source
    var shouldShowMealPlaceholder: Bool {
        return !isAnyMealLogged
    }
    
    var shouldShowTagsPlaceholder: Bool {
        return !isAnyTagAdded
    }
    
    func numberOfItems() -> Int {
        return 1
    }
    
    func itemForMeal(row: Int) -> MealModel? {
        let meal = recentMeal?[row]
        return meal
    }
    
    func itemForPlaceholder(row: Int) -> [String] {
        
        return placeholderUrls
    }
    
    // MARK: - Events
    
    func didSelectRow(_ row: Int, from controller: UIViewController) {
        guard let meal = recentMeal?[row] else { return }
        coordinatorDelegate?.goToMealEditor(meal: meal, from: controller)
    }
    
}
