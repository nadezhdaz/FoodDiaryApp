//
//  MealEditorCoordinator.swift
//  TakeEatEasy
//
//  Created by Nadezhda Zenkova on 11.11.2021.
//

import UIKit

protocol MealEditorCoordinatorDelegate {
    func didFinish(from coordinator: MealEditorCoordinator)
}

class MealEditorCoordinator: Coordinator {
    
    // MARK: - Properties
    
    var rootViewController: MealEditorViewController
    
    var presentingController: UIViewController
    
    let rootNavigationController: UINavigationController = {
        let navVC = UINavigationController()
        return navVC
    }()
    
    var persistentData: CoreDataServiceType
    
    var delegate: MealEditorCoordinatorDelegate
    
    // MARK: VM / VC's
    
    var mealEditorViewModel: MealEditorViewModel
    
    // MARK: - Coordinator
    init(controller: MealEditorViewController, presentingController:  UIViewController, meal: MealModel?, persistentData: CoreDataServiceType, apiClient: EveryPixelApiClientType, defaults: UserDefaultsDataServiceType, delegate: MealEditorCoordinatorDelegate) {
        mealEditorViewModel = MealEditorViewModel(meal: meal, service: TagsRecognitionApiService(apiClient: apiClient), datasource: persistentData, defaults: defaults)
        self.rootViewController = controller
        self.presentingController = presentingController
        self.persistentData = persistentData
        self.delegate = delegate
    }
    
    override func start() {
        mealEditorViewModel.coordinatorDelegate = self
        rootViewController.viewModel = mealEditorViewModel
        //let homeVC: MealEditorViewController = MealEditorViewController()
        //rootViewController.viewModel = homeViewModel
        //rootNavigationController.setViewControllers([rootViewController], animated: false)
        presentingController.present(rootViewController, animated: true)
    }
    
    override func finish() {
        // Clean up any view controllers. Pop them of the navigation stack for example.
        //delegate.didFinish(from: self)
    }
    
}


// MARK: - Navigation
extension MealEditorCoordinator {
    
    
    
}

// MARK: - Coordinator Callback's
extension MealEditorCoordinator: MealEditorCoordinatorDelegate {
    
    func didFinish(from coordinator: MealEditorCoordinator) {
        removeChildCoordinator(coordinator)
    }
    
}

// MARK: - ViewModel Callback's
extension MealEditorCoordinator: MealEditorViewModelCoordinatorDelegate {
    func reloadDataChanges() {
        
    }
    
    func didSelectClose(from viewModel: MealEditorViewModel, from controller: MealEditorViewModelViewDelegate) {
        delegate.didFinish(from: self)
    }
    
    
    
}
