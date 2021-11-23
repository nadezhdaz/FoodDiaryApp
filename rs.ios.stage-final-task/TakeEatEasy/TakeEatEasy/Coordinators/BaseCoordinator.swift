//
//  BaseCoordinator.swift
//  TakeEatEasy
//
//  Created by Nadezhda Zenkova on 09.11.2021.
//

import UIKit

class BaseCoordinator: Coordinator {
    
    // MARK: - Properties
    
    let window: UIWindow?
    
    private let dataService = UserDefaultsDataService()
    
    private var colors = ColorTheme()
    
    var rootViewController: UIViewController?
    
    
    // MARK: - Coordinator
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    override func start() {
        dataService.fetchUserState { [weak self] isFirstTimeUser in
            self?.route(isFirstTimeUser: isFirstTimeUser)
        }
        ColorTheme().themeName = dataService.fetchColorTheme()
        ColorTheme().start()
    }
    
    override func finish() {
        
    }
    
}

// MARK: - Routing

private extension BaseCoordinator {
    
    func route(isFirstTimeUser: Bool) {
        guard let window = window else {
            return
        }
        let onboardingVc = OnboardingViewController(viewModel: OnboardingViewModel())
        onboardingVc.viewModel.coordinatorDelegate = self
        let onboardingCoordinator = OnboardingCoordinator(viewController: onboardingVc, rootCoordinator: self)
        onboardingCoordinator.start()
        
        window.rootViewController = onboardingVc
        window.makeKeyAndVisible()
        
        if isFirstTimeUser {
            let onboardingVc = OnboardingViewController(viewModel: OnboardingViewModel())
            onboardingVc.viewModel.coordinatorDelegate = self
            let onboardingCoordinator = OnboardingCoordinator(viewController: onboardingVc, rootCoordinator: self)
            onboardingCoordinator.start()
            
            window.rootViewController = onboardingVc
            window.makeKeyAndVisible()
        } else {
            let tabBarVc = TabBarViewController()
            let persistentData = CoreDataService(container: "TakeEatEasy")
            let tabBarCoordinator = TabBarCoordinator(tabBarVc, placeholdersClient: FoodishApiClient(), imageRecognitionClient: EveryPixelApiClient(), persistentData: persistentData, defaults: UserDefaultsDataService())
            tabBarCoordinator.start()            
            
            window.rootViewController = tabBarVc
            window.makeKeyAndVisible()
            //animateRouting(to: tabBarVc)
        }
        
    }
    
}

// MARK: - Onboarding Coordinator Delegate

extension BaseCoordinator: OnboardingViewModelCoordinatorDelegate {
    func didSelectClose(from viewModel: OnboardingViewModel, from controller: UIViewController) {
        
        let isFirstTimeUser = false
        dataService.set(isFirstTimeUser: isFirstTimeUser)
        route(isFirstTimeUser: isFirstTimeUser)
    }
    
    
    //func onboardingCoordinatorDidFinish(_ coordinator: OnboardingCoordinator) {
   //     let isFirstTimeUser = false
   //     dataService.set(isFirstTimeUser: isFirstTimeUser)
   //     route(isFirstTimeUser: isFirstTimeUser)
   // }
    
}

// MARK: - Animation

private extension BaseCoordinator {
    private func animateRouting(to controller: UIViewController) {
        controller.view.alpha = 0.0
        
        UIView.animate(withDuration: 2.0, animations: {
            controller.view.alpha = 1.0
        })
    }
    
}
