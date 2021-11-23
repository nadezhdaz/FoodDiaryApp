//
//  TabBarViewController.swift
//  TakeEatEasy
//
//  Created by Nadezhda Zenkova on 03.11.2021.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    public var coordinatorDelegate: TabBarCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setValue(RaisedButtonTabbar(frame: tabBar.frame), forKey: "tabBar")
        view.backgroundColor = .backgroundColor
        //setupTabBarController()
        delegate = self
    }
    
    public func createTabBarController(home: HomeViewController, history: HistoryViewController, statistics: StatisticsViewController, settings: SettingsViewController) {
        home.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        history.tabBarItem = UITabBarItem(title: "History", image: UIImage(systemName: "tray.full.fill"), tag: 1)
        statistics.tabBarItem = UITabBarItem(title: "Statistics", image: UIImage(systemName: "chart.bar"), tag: 2)
        settings.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 3)
        
        let controllers = [home, history, statistics, settings]
        viewControllers = controllers.map{ UINavigationController(rootViewController: $0) }
        
        setupTabBarController()
    }
    
    private func setupTabBarController() {
        guard let tabItems = tabBar.items else { return }
        tabItems[0].titlePositionAdjustment = UIOffset(horizontal: -15, vertical: 0)
        tabItems[1].titlePositionAdjustment = UIOffset(horizontal: -30, vertical: 0)
        tabItems[2].titlePositionAdjustment = UIOffset(horizontal: 30, vertical: 0)
        tabItems[3].titlePositionAdjustment = UIOffset(horizontal: 15, vertical: 0)
        
        tabBar.backgroundColor = .defaultTabBarColor
        tabBar.barTintColor = .defaultTabBarColor
        tabBar.tintColor = .lightYellow
        tabBar.unselectedItemTintColor = .lightGray
        
        let tabs = tabBar as? RaisedButtonTabbar
        tabs?.presentingDelegate = coordinatorDelegate!
    }
    
}

extension TabBarViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TabBarTransitionManager(viewControllers: tabBarController.viewControllers)
    }
}
    

extension TabBarViewController: RaisedTabbarButtonDelegate {
    func didTapRaisedButton() {
        coordinatorDelegate?.goToMealEditor(meal: nil, from: self)
        
        //present(MealEditorViewController(), animated: true, completion: nil)
    }
    
}
