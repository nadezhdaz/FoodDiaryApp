//
//  OnboardingViewModel.swift
//  TakeEatEasy
//
//  Created by Nadezhda Zenkova on 09.11.2021.
//

import UIKit

protocol OnboardingViewModelType {
    // Data Source
    
    var slidingText: [String] { get }
    
    var coordinatorDelegate: OnboardingViewModelCoordinatorDelegate? { get set }
    
    // Events
    
    func didSelectClose(from controller: UIViewController)
    
}

protocol OnboardingViewModelCoordinatorDelegate: class {
    
    func didSelectClose(from viewModel: OnboardingViewModel, from controller: UIViewController)
    
}

class OnboardingViewModel {
    
    // MARK: - Delegates
    
    var coordinatorDelegate: OnboardingViewModelCoordinatorDelegate?
    
    // MARK: - Properties
    fileprivate let onboardingText = ["Take Eat Easy app is an efficient tool for your physical and mental health. You can track your food and mood changes.", "You can observe variety and trends of your meals. I believe that eating is for making you moodAfter, not frustrated.", "Add photos of your meals, than app suggests tags guessing food on the photo.", "Also you can track how hungry or moodAfter you were after the meal.\n Enjoy your food!"]
    
    
}

extension OnboardingViewModel: OnboardingViewModelType {
    
    // MARK: - Data Source
    
    var slidingText: [String] {
        return onboardingText
    }
    
    // MARK: - Events
    
    func didSelectClose(from controller: UIViewController) {
        coordinatorDelegate?.didSelectClose(from: self, from: controller)
    }
    
}
