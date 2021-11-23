//
//  HistoryCoordinator.swift
//  TakeEatEasy
//
//  Created by Nadezhda Zenkova on 09.11.2021.
//

import UIKit

protocol HistoryCoordinatorDelegate {
    //func didFinish(from: HomeCoordinator)
    func didFinishMealEditor()
}

class HistoryCoordinator: Coordinator {
    
    // MARK: - Properties
    
    var rootViewController: HistoryViewController
    
    let rootNavigationController: UINavigationController = {
        let navVC = UINavigationController()
        return navVC
    }()
    
    var persistentData: CoreDataServiceType
    
    var delegate: HistoryCoordinatorDelegate?
    
    var imageApiClient: EveryPixelApiClientType
    
    var defaults: UserDefaultsDataServiceType
    // MARK: VM / VC's
    
    var historyViewModel: HistoryViewModel
    
    // MARK: - Coordinator
    init(controller: HistoryViewController, persistentData: CoreDataServiceType, apiClient: FoodishApiClientType, imageApiClient: EveryPixelApiClientType, defaults: UserDefaultsDataServiceType) {
        self.persistentData = persistentData
        self.defaults = defaults
        self.imageApiClient = imageApiClient
        self.rootViewController = controller
        historyViewModel = HistoryViewModel(service: FoodPlaceholderApiService(apiClient: apiClient), datasource: persistentData)
        rootViewController.viewModel = historyViewModel
        
    }
    
    override func start() {
        historyViewModel.coordinatorDelegate = self
    }
    
    override func finish() {
        
    }
    
    override func reloadData() {
        rootViewController.updateScreen()
    }
    
}

// MARK: - Navigation
extension HistoryCoordinator: MealEditorCoordinatorDelegate {
    
    func didFinish(from coordinator: MealEditorCoordinator) {
        removeChildCoordinator(coordinator)
    }
    
}

// MARK: - ViewModel Callback's
extension HistoryCoordinator: HistoryViewModelCoordinatorDelegate {
    
    func goToMealEditor(meal: MealModel, from controller: UIViewController) {
        let mealCoordinator = MealEditorCoordinator(controller: MealEditorViewController(), presentingController: rootViewController, meal: meal, persistentData: persistentData, apiClient: imageApiClient, defaults: defaults, delegate: self)
        mealCoordinator.delegate = self
        mealCoordinator.start()
        //mealCoordinator.mealModel = meal
        //mealCoordinator.fromController
        addChildCoordinator(mealCoordinator)
    }
    
}
