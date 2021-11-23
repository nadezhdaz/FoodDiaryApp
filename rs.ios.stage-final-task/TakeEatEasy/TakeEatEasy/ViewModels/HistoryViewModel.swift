//
//  HistoryViewModel.swift
//  TakeEatEasy
//
//  Created by Nadezhda Zenkova on 09.11.2021.
//

import UIKit

protocol HistoryViewModelType {
    
    // Data Source
    
    var viewDelegate: HistoryViewModelViewDelegate? { get set }
    
    var shouldShowMealPlaceholder: Bool { get }
    
    func numberOfItems() -> Int
    
    func itemFor(row: Int) -> MealModel?
    
    func getFoodPlaceholder(completion: @escaping (String) -> Void)
    
    // Events
    func start()
    
    func didSelectRow(_ row: Int, from controller: UIViewController)
    
}

protocol HistoryViewModelCoordinatorDelegate: class {    
    
    func goToMealEditor(meal: MealModel, from: UIViewController)
    
}

protocol HistoryViewModelViewDelegate: class {
    
    func updateScreen()
    
    func showMealPlaceholder()
    
    func showError(_ message: String)
    
    //func updateState(_ state: ViewControllerState)
    
}

class HistoryViewModel {
    
    // MARK: - Delegates
    weak var coordinatorDelegate: HistoryViewModelCoordinatorDelegate?
    
    weak var viewDelegate: HistoryViewModelViewDelegate?
    
    // MARK: - Properties
    fileprivate let service: FoodPlaceholderApiService
    
    fileprivate let datasource: CoreDataServiceType
    
    fileprivate var meals: [MealModel]?
    
    fileprivate var placeholderUrls: [String]?
    
    fileprivate var isAnyMealLogged = false
    
    // MARK: - Init
    init(service: FoodPlaceholderApiService, datasource: CoreDataServiceType) {
        self.service = service
        self.datasource = datasource
    }
    
    func start() {
        getMeals()
    }
    
    // MARK: - Core Data
    
    func getMeals() {
        if let meals = datasource.fetchMeals() {
            self.meals = meals
            self.isAnyMealLogged = true
            viewDelegate?.updateScreen()
        } else {
            self.isAnyMealLogged = false
            viewDelegate?.showMealPlaceholder()
            viewDelegate?.updateScreen()
        }
    }
    
    // MARK: - Network
    
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

extension HistoryViewModel: HistoryViewModelType {
    
    // MARK: - Data Source
    var shouldShowMealPlaceholder: Bool {
        return !isAnyMealLogged
    }
    
    func numberOfItems() -> Int {
        guard let meals = meals else { return 0 }
        return meals.count
    }
    
    func itemFor(row: Int) -> MealModel? {
        let meal = meals?[row]
        return meal
    }
    
    // MARK: - Events
    
    func didSelectRow(_ row: Int, from controller: UIViewController) {
        guard let meal = meals?[row] else { return }
        coordinatorDelegate?.goToMealEditor(meal: meal, from: controller)
    }
    
}
