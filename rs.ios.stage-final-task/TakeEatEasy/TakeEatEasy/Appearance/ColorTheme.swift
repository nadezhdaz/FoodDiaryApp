//
//  ColorTheme.swift
//  TakeEatEasy
//
//  Created by Nadezhda Zenkova on 04.11.2021.
//

import UIKit

protocol ColorThemeType {
    var backgroundSecondary: UIColor { get }
    var background: UIColor { get }
    var mainLabel: UIColor { get }
    var tagBorder: UIColor { get }
    var buttonBackground: UIColor { get }
    var buttonText: UIColor { get }
}

struct GreenTheme: ColorThemeType {
    var background: UIColor {
        return .lightGreen
    }
    
    var backgroundSecondary: UIColor {
        return .veryLightGreen
    }
    
    var mainLabel: UIColor {
        return .darkGreen
    }
    
    var tagBorder: UIColor {
        return .darkGreen
    }
    
    var buttonBackground: UIColor {
        return .darkGreen
    }
    
    var buttonText: UIColor {
        return .white
    }
    
}

struct BlueTheme: ColorThemeType {
    var background: UIColor {
        return .lightBlue
    }
    
    var backgroundSecondary: UIColor {
        return .veryLightBlue
    }
    
    var mainLabel: UIColor {
        return .darkBlue
    }
    
    var tagBorder: UIColor {
        return .darkBlue
    }
    
    var buttonBackground: UIColor {
        return .darkBlue
    }
    
    var buttonText: UIColor {
        return .white
    }
}

struct YellowTheme: ColorThemeType {
    var background: UIColor {
        return .lightYellow
    }
    
    var backgroundSecondary: UIColor {
        return .veryLightYellow
    }
    
    var mainLabel: UIColor {
        return .darkYellow
    }
    
    var tagBorder: UIColor {
        return .darkYellow
    }
    
    var buttonBackground: UIColor {
        return .darkYellow
    }
    
    var buttonText: UIColor {
        return .darkBlue
    }
}



final class ColorTheme {
    
    let colorThemes: [ Colors : ColorThemeType ] = [ Colors.green : GreenTheme(), Colors.blue : BlueTheme(), Colors.yellow : YellowTheme() ]
    
    // MARK: - Properties
    static let shared = ColorTheme()
    var theme: ColorThemeType?
    var themeName: Colors?
    
    init() {
        let defaults = UserDefaultsDataService()
        let name = defaults.fetchColorTheme()
        self.theme = colorThemes[name]
    }
    
    func start() {
        let defaults = UserDefaultsDataService()
        let name = defaults.fetchColorTheme()
        if let theme = colorThemes[name] {
            self.theme = theme
        }
    }
}

extension UIColor {
    
    static func initWithColorScheme(_ scheme: Colors){
        switch scheme {
        case .green:
            secondaryBackground = .veryLightGreen
        case .blue:
            secondaryBackground = .veryLightBlue
        case .yellow:
            secondaryBackground = .veryLightYellow
        }
    }
    
    @nonobjc static var secondaryBackground: UIColor!


    
    @nonobjc class var backgroundColor: UIColor
    {
        return ColorTheme.shared.theme?.background ?? GreenTheme().background
    }
    
    @nonobjc class var backgroundSecondaryColor: UIColor
    {
        return ColorTheme.shared.theme?.backgroundSecondary ?? GreenTheme().backgroundSecondary
    }
    
    @nonobjc class var mainLabelColor: UIColor
    {
        return ColorTheme.shared.theme?.mainLabel ?? GreenTheme().mainLabel
    }
    
    @nonobjc class var tagBorderColor: UIColor
    {
        return ColorTheme.shared.theme?.tagBorder ?? GreenTheme().tagBorder
    }
    
    @nonobjc class var buttonBackgroundColor: UIColor
    {
        return ColorTheme.shared.theme?.buttonBackground ?? GreenTheme().buttonBackground
    }
    
    @nonobjc class var buttonTextColor: UIColor
    {
        return ColorTheme.shared.theme?.buttonText ?? GreenTheme().buttonText
    }
}
