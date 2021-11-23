//
//  SettingsViewModel.swift
//  TakeEatEasy
//
//  Created by Nadezhda Zenkova on 09.11.2021.
//

import UIKit

enum SettingsType: CaseIterable {
    case accuracy
    case colorTheme
}

enum Colors{
    case green
    case blue
    case yellow
}

protocol SettingsViewModelType {
    
    // Data Source
    
    var currentAccuracy: Float { get }
    
    var currentColorTheme: Colors { get }
    
    func numberOfItems() -> Int
    
    func itemFor(row: Int) -> SettingsType
    
    //var shouldShowSettingsPlaceholder: Bool { get }
    
    // Events
    func start()
    
    func setupAccuracy(_ number: Float)
    
    func setupColorTheme(_ name: Colors)
    
    var viewDelegate: SettingsViewModelViewDelegate? { get set }
    
}

protocol SettingsViewModelViewDelegate: class {
    
    func updateScreen(with scheme: Colors)
    
}

class SettingsViewModel {
    
    // MARK: - Delegates
    
    var viewDelegate: SettingsViewModelViewDelegate?
    
    // MARK: - Properties
    
    fileprivate let defaults: UserDefaultsDataServiceType
    
    fileprivate var tagAccuracy: Double?
    
    fileprivate var colorTheme: ColorTheme?
    
    // MARK: - Init
    init(defaults: UserDefaultsDataServiceType) {
        self.defaults = defaults
    }
    
    func start() {
        getCurrentSettings()
    }
    
    // MARK: - User defaults
    
    func getCurrentSettings() {
        
    }
    
}

extension SettingsViewModel: SettingsViewModelType {
    var currentAccuracy: Float {
        get {
            return defaults.fetchTagAccuracy()
        }
        set {
            
        }
    }
    
    var currentColorTheme: Colors {
        get {
            return defaults.fetchColorTheme()
        }
        set {
            
        }
    }
    
    func setupAccuracy(_ number: Float) {
        defaults.setTagAccuracy(number)
    }
    
    func setupColorTheme(_ color: Colors) {
        defaults.setColorTheme(color)
        //ColorTheme().themeName = defaults.fetchColorTheme()
        //ColorTheme().start()
        viewDelegate?.updateScreen(with: color)
    }
    
    func itemFor(row: Int) -> SettingsType {
        return SettingsType.allCases[row] 
    }
    
    func numberOfItems() -> Int {
        return SettingsType.allCases.count
    }
    
    
    // MARK: - Data Source
    
    // MARK: - Events
    
    
}
