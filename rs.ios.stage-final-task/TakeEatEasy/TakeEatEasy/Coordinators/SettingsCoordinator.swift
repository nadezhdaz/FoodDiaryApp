//
//  SettingsCoordinator.swift
//  TakeEatEasy
//
//  Created by Nadezhda Zenkova on 09.11.2021.
//

import UIKit

protocol SettingsCoordinatorDelegate {
    //func didFinish(from: HomeCoordinator)
}

class SettingsCoordinator: Coordinator {
    // MARK: - Properties
    
    var rootViewController: SettingsViewController
    
    let rootNavigationController: UINavigationController = {
        let navVC = UINavigationController()
        return navVC
    }()
    
    var delegate: SettingsCoordinatorDelegate?
    
    // MARK: VM / VC's
    
    var settingsViewModel: SettingsViewModel
    
    // MARK: - Coordinator
    init(controller: SettingsViewController, defaults: UserDefaultsDataServiceType) {
        settingsViewModel = SettingsViewModel(defaults: defaults)
        self.rootViewController = controller
        //statiscticsViewModel.coordinatorDelegate = self
        
    }
    
    override func start() {
        rootViewController.viewModel = settingsViewModel
        //let homeVC: HomeViewController = HomeViewController()
        //rootViewController.viewModel = homeViewModel
        //rootNavigationController.setViewControllers([rootViewController], animated: false)
    }
    
    override func finish() {
        // Clean up any view controllers. Pop them of the navigation stack for example.
        //delegate.didFinish(from: self)
    }
    
    override func reloadData() {
        
    }
    
}

// MARK: - Coordinator Callback's
extension SettingsCoordinator: SettingsCoordinatorDelegate {
    
    func didFinish(from coordinator: SettingsCoordinator) {
        removeChildCoordinator(coordinator)
    }
    
}
