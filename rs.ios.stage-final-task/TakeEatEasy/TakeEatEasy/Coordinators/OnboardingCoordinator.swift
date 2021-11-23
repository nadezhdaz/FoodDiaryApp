//
//  OnboardingCoordinator.swift
//  TakeEatEasy
//
//  Created by Nadezhda Zenkova on 09.11.2021.
//

import UIKit

    // MARK: - Delegate

//protocol OnboardingCoordinatorDelegate: class {
//    func onboardingCoordinatorDidFinish(_ coordinator: OnboardingCoordinator)
//}

class OnboardingCoordinator: Coordinator {
    
    // MARK: - Properties
    
    let viewController: OnboardingViewController
    
    //let rootNavigationController: UINavigationController = {
    //    let navVC = UINavigationController()
    //    return navVC
    //}()
    
    weak var rootCoordinator: BaseCoordinator?
    
    // MARK: VM / VC's
    lazy var onboardingViewModel: OnboardingViewModel = {
        let viewModel = OnboardingViewModel()
        viewModel.coordinatorDelegate = rootCoordinator
        return viewModel
    }()
    
    // MARK: - Coordinator
    
    init(viewController: OnboardingViewController, rootCoordinator: BaseCoordinator) {
        self.viewController = viewController
    }
    
    override func start() {
        //let vc = OnboardingViewController()
        //let vm = OnboardingViewModel()
        //vc.viewModel = vm
        ///navigationController.setViewControllers([vc], animated: true)
        
        ///let onboardingVC: SearchInputViewController = storyboard.instantiateViewController()
        ///rootViewController.viewModel = onboardingViewModel
        //rootNavigationController.setViewControllers([vc], animated: false)
        
        ///rootViewController.setViewControllers([rootNavigationController], animated: false)
    }
    
    override func finish() {
        // Clean up any view controllers. Pop them of the navigation stack for example.
        didFinish(from: self)
    }
    
}

// MARK: - Coordinator Callback's

extension OnboardingCoordinator {
    
    func didFinish(from coordinator: OnboardingCoordinator) {
        removeChildCoordinator(self)
    }
    
}
