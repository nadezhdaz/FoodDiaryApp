//
//  TabBarCoordinator.swift
//  TakeEatEasy
//
//  Created by Nadezhda Zenkova on 09.11.2021.
//

import UIKit

class TabBarCoordinator: Coordinator {
    
    // MARK: - Properties
    
    var rootViewController: UIViewController {
        return tabController
    }
    
    let tabController: TabBarViewController
    
    let homeCoordinator: HomeCoordinator
    let historyCoordinator: HistoryCoordinator
    let statisticsCoordinator: StatisticsCoordinator
    let settingsCoordinator: SettingsCoordinator
    
    let persistentData: CoreDataServiceType
    let imageRecognitionClient: EveryPixelApiClientType
    let defaults: UserDefaultsDataServiceType
    
    var coordinators: [Coordinator] {
        return [homeCoordinator, historyCoordinator, statisticsCoordinator, settingsCoordinator]
    }
    
    // MARK: - Coordinator
    init(_ rootViewController: TabBarViewController, placeholdersClient: FoodishApiClientType, imageRecognitionClient: EveryPixelApiClientType, persistentData: CoreDataServiceType, defaults: UserDefaultsDataServiceType) {
        self.tabController = rootViewController
        self.persistentData = persistentData
        self.defaults = defaults
        self.imageRecognitionClient = imageRecognitionClient
        homeCoordinator = HomeCoordinator(controller: HomeViewController(), persistentData: persistentData, apiClient: placeholdersClient, imageApiClient: imageRecognitionClient, defaults: defaults)
        historyCoordinator = HistoryCoordinator(controller: HistoryViewController(), persistentData: persistentData, apiClient: placeholdersClient, imageApiClient: imageRecognitionClient, defaults: defaults)
        statisticsCoordinator = StatisticsCoordinator(controller: StatisticsViewController(), persistentData: persistentData)
        settingsCoordinator = SettingsCoordinator(controller: SettingsViewController(), defaults: defaults)
        
        homeCoordinator.start()
        historyCoordinator.start()
        statisticsCoordinator.start()
        settingsCoordinator.start()
    }
    
    override func start() {
        tabController.coordinatorDelegate = self
        homeCoordinator.delegate = self
        historyCoordinator.delegate = self
        statisticsCoordinator.delegate = self
        settingsCoordinator.delegate = self
        tabController.createTabBarController(home: homeCoordinator.rootViewController, history: historyCoordinator.rootViewController, statistics: statisticsCoordinator.rootViewController, settings: settingsCoordinator.rootViewController)
        
        //tabController.delegate = self
    }
    
    override func finish() {
        // Clean up any view controllers. Pop them of the navigation stack for example.
        //delegate?.didFinish(from: self)
    }
    
}


// MARK: - Navigation
extension TabBarCoordinator: HomeCoordinatorDelegate, HistoryCoordinatorDelegate, StatisticsCoordinatorDelegate, SettingsCoordinatorDelegate, RaisedTabbarButtonDelegate, MealEditorCoordinatorDelegate {
    
    func switchToHome() {
        tabController.selectedIndex = 0
    }
    
    func switchToHistory() {
        tabController.selectedIndex = 0
    }
    
    func switchToStatistics() {
        tabController.selectedIndex = 0
    }
    
    func switchToSettingg() {
        tabController.selectedIndex = 0
    }
    
    func didFinish(from coordinator: HistoryCoordinator) {
        removeChildCoordinator(coordinator)
    }
    
    func didFinishMealEditor() {
        for coordinator in coordinators {
            coordinator.reloadData()
        }
    }
    
    func didTapRaisedButton() {
        let mealCoordinator = MealEditorCoordinator(controller: MealEditorViewController(), presentingController: rootViewController, meal: nil, persistentData: persistentData, apiClient: imageRecognitionClient, defaults: defaults, delegate: self)
        mealCoordinator.start()
    }
    
    func didFinish(from coordinator: MealEditorCoordinator) {
        coordinator.rootViewController.dismiss(animated: true, completion: nil)
        for coordinator in coordinators {
            coordinator.reloadData()
        }
    }
    
    func goToMealEditor(meal: MealModel?, from controller: UIViewController) {
        let mealCoordinator = MealEditorCoordinator(controller: MealEditorViewController(), presentingController: rootViewController, meal: nil, persistentData: persistentData, apiClient: imageRecognitionClient, defaults: defaults, delegate: self)
        mealCoordinator.delegate = self
        addChildCoordinator(mealCoordinator)
        mealCoordinator.start()
    }
    
}
