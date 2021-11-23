//
//  Coordinator.swift
//  TakeEatEasy
//
//  Created by Nadezhda Zenkova on 09.11.2021.
//

import UIKit

public protocol CoordinatorType: class {
    var rootViewController: UIViewController { get }
}

class Coordinator {    
    
    private(set) var childrenCoordinators: [Coordinator] = []
    
    func start() {
        preconditionFailure("This method needs to be overriden by subclass.")
    }
    
    func finish() {
        preconditionFailure("This method needs to be overriden by subclass.")
    }
    
    func reloadData() {
        
    }
    
    func addChildCoordinator(_ coordinator: Coordinator) {
        childrenCoordinators.append(coordinator)
    }
    
    func removeChildCoordinator(_ coordinator: Coordinator) {
        if let index = childrenCoordinators.firstIndex(of: coordinator) {
            childrenCoordinators.remove(at: index)
        } else {
            print("Couldn't remove coordinator: \(coordinator). It's not a child coordinator.")
        }
    }
    
    func removeAllChildCoordinatorsWith<T>(type: T.Type) {
        childrenCoordinators = childrenCoordinators.filter { $0 is T  == false }
    }
    
    func removeAllChildCoordinators() {
        childrenCoordinators.removeAll()
    }
    
}

extension Coordinator: Equatable {
    
    static func == (lhs: Coordinator, rhs: Coordinator) -> Bool {
        return lhs === rhs
    }
    
}
