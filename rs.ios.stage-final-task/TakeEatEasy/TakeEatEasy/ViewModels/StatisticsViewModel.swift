//
//  StatisticsViewModel.swift
//  TakeEatEasy
//
//  Created by Nadezhda Zenkova on 09.11.2021.
//

import UIKit

protocol StatisticsViewModelType {
    
    // Data Source
    
    func getMeals() -> [MealModel]?
    
    var shouldShowStatisticsPlaceholder: Bool { get }
    
    // Events
    func start()
    
}

protocol StatisticsViewModelViewDelegate: class {
    
    func showStatisticsPlaceholder()
    
    func updateScreen()
    
}

class StatisticsViewModel {
    
    // MARK: - Delegates
    
    weak var viewDelegate: StatisticsViewModelViewDelegate?
    
    // MARK: - Properties
    
    fileprivate let datasource: CoreDataServiceType
    
    fileprivate var meals: [MealModel]?
    
    fileprivate var isAnyMealLogged = false
    
    // MARK: - Init
    init(datasource: CoreDataServiceType) {
        self.datasource = datasource
    }
    
    func start() {
        getStatisctics()
    }
    
    // MARK: - Core Data
    
    func getStatisctics() {
        if let meals = datasource.fetchMealStatistics() {
            self.meals = meals
            self.isAnyMealLogged = true
            viewDelegate?.updateScreen()
        } else {
            self.isAnyMealLogged = false
            viewDelegate?.showStatisticsPlaceholder()
            viewDelegate?.updateScreen()
        }
    }
    
}

extension StatisticsViewModel: StatisticsViewModelType {
    func getMeals() -> [MealModel]? {
        return meals
    }
    
    
    // MARK: - Data Source
    var shouldShowStatisticsPlaceholder: Bool {
        return !isAnyMealLogged
    }
    
}
