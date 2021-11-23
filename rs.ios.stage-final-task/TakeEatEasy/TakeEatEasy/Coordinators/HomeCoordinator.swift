//
//  HomeCoordinator.swift
//  TakeEatEasy
//
//  Created by Nadezhda Zenkova on 09.11.2021.
//

import UIKit

protocol HomeCoordinatorDelegate {
    //func didFinish(from: HomeCoordinator)
}

class HomeCoordinator: Coordinator {
    
    // MARK: - Properties
    
    var rootViewController: HomeViewController
    
    let rootNavigationController: UINavigationController = {
        let navVC = UINavigationController()
        return navVC
    }()
    
    var persistentData: CoreDataServiceType
    
    var delegate: HomeCoordinatorDelegate?
    
    var imageApiClient: EveryPixelApiClientType
    
    var defaults: UserDefaultsDataServiceType
    
    // MARK: VM / VC's
    
    var homeViewModel: HomeViewModel
    
    // MARK: - Coordinator
    init(controller: HomeViewController, persistentData: CoreDataServiceType, apiClient: FoodishApiClientType, imageApiClient: EveryPixelApiClientType, defaults: UserDefaultsDataServiceType) {
        homeViewModel = HomeViewModel(service: FoodPlaceholderApiService(apiClient: apiClient), datasource: persistentData)
        self.rootViewController = controller
        rootViewController.viewModel = homeViewModel
        self.persistentData = persistentData
        self.imageApiClient = imageApiClient
        self.defaults = defaults
    }
    
    override func start() {
        homeViewModel.coordinatorDelegate = self
    }
    
    override func finish() {
    }
    
    override func reloadData() {
        rootViewController.updateScreen()
    }
    
}


// MARK: - Navigation
extension HomeCoordinator: MealEditorCoordinatorDelegate {
    
    func didFinish(from coordinator: MealEditorCoordinator) {
        removeChildCoordinator(coordinator)
    }
    
}

// MARK: - Coordinator Callback's
extension HomeCoordinator: HomeCoordinatorDelegate {
    
    func didFinish(from coordinator: HomeCoordinator) {
        removeChildCoordinator(coordinator)
    }
    
}

// MARK: - ViewModel Callback's
extension HomeCoordinator: HomeViewModelCoordinatorDelegate {
    
    func goToMealEditor(meal: MealModel, from controller: UIViewController) {
        let mealCoordinator = MealEditorCoordinator(controller: MealEditorViewController(), presentingController: rootViewController, meal: meal, persistentData: persistentData, apiClient: imageApiClient, defaults: defaults, delegate: self)
        mealCoordinator.delegate = self
        addChildCoordinator(mealCoordinator)
        mealCoordinator.start()
    }
    
}
