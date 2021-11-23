//
//  UserDefaultsDataService.swift
//  TakeEatEasy
//
//  Created by Nadezhda Zenkova on 09.11.2021.
//

import UIKit

protocol UserDefaultsDataServiceType {
    
    func fetchUserState(isFirstTimeUser: @escaping (Bool) -> Void)
    func set(isFirstTimeUser: Bool)
    
    func fetchTagAccuracy() -> Float
    func setTagAccuracy(_ accuracy: Float)
    
    func fetchColorTheme() -> Colors
    func setColorTheme(_ colorTheme: Colors)
}

class UserDefaultsDataService {
    
    private let defaults = UserDefaults.standard
    private let defaultColorTheme = Colors.green
    private let defaultAccuracy: Float = 0.5
    
    init() {
        setTagAccuracy(defaultAccuracy)
        setColorTheme(defaultColorTheme)
    }
    
}

// MARK: - User Statert

extension UserDefaultsDataService: UserDefaultsDataServiceType {
    
    private var tagAccuracyKey: String { return "TagAccuracy" }
    private var userStateKey: String { return "FirstTimeUser" }
    private var colorThemeKey: String { return "ColorTheme" }
    
    func setColorTheme(_ colorTheme: Colors) {
        let color: String
        switch colorTheme {
        case .green:
            color = "green"
        case .blue:
            color = "blue"
        case .yellow:
            color = "yellow"
        }
        
        defaults.set(color, forKey: colorThemeKey)
    }
    
    func fetchColorTheme() -> Colors {
        guard let color = defaults.string(forKey: colorThemeKey) else { return defaultColorTheme }
        switch color {
        case "green":
            return .green
        case "blue":
            return .blue
        case "yellow":
            return .yellow
        default:
            return defaultColorTheme
        }
    }
    
    func fetchTagAccuracy() -> Float {
         return defaults.float(forKey: tagAccuracyKey)
    }
    
    func setTagAccuracy(_ accuracy: Float) {
        defaults.set(accuracy, forKey: tagAccuracyKey)
    }
    
    
    
    func fetchUserState(isFirstTimeUser: @escaping (Bool) -> Void) {
        isFirstTimeUser(defaults.string(forKey: userStateKey) == nil)
    }
    
    func set(isFirstTimeUser: Bool) {
        isFirstTimeUser ? defaults.removeObject(forKey: userStateKey) : defaults.set(userStateKey, forKey: userStateKey)
    }
    
}
