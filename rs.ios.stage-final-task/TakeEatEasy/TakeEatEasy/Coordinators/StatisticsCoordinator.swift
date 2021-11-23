//
//  StatisticsCoordinator.swift
//  TakeEatEasy
//
//  Created by Nadezhda Zenkova on 09.11.2021.
//

import UIKit

protocol StatisticsCoordinatorDelegate {
    //func didFinish(from: HomeCoordinator)
}

class StatisticsCoordinator: Coordinator {
    // MARK: - Properties
    
    var rootViewController: StatisticsViewController
    
    let rootNavigationController: UINavigationController = {
        let navVC = UINavigationController()
        return navVC
    }()
    
    var persistentData: CoreDataServiceType!
    
    var delegate: StatisticsCoordinatorDelegate!
    
    // MARK: VM / VC's
    
    var statiscticsViewModel: StatisticsViewModel
    
    // MARK: - Coordinator
    init(controller: StatisticsViewController, persistentData: CoreDataServiceType) {
        statiscticsViewModel = StatisticsViewModel(datasource: persistentData)
        self.rootViewController = controller
        rootViewController.viewModel = statiscticsViewModel
    }
    
    override func start() {
    }
    
    override func finish() {
        
    }
    
    override func reloadData() {
        rootViewController.updateScreen()
    }
    
}

// MARK: - Coordinator Callback's
extension StatisticsCoordinator: StatisticsCoordinatorDelegate {
    
    func didFinish(from coordinator: HomeCoordinator) {
        removeChildCoordinator(coordinator)
    }
    
}
