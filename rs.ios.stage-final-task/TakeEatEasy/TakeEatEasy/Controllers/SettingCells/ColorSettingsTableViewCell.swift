//
//  ColorSettingsTableViewCell.swift
//  TakeEatEasy
//
//  Created by Nadezhda Zenkova on 17.11.2021.
//

import UIKit

class ColorSettingsTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let cellId = "ColorSettingsTableViewCell"
    
    public var colorButtonsTapHandler: ((Colors) -> Void)?
    
    private var selectedColorScheme: Colors?
    
    @IBOutlet weak var greenButton: CircleColoredButton!
    @IBAction func greenSchemeButtonPressed(_ sender: Any) {
        updateColorTheme(.green)
    }
    
    @IBOutlet weak var blueButton: CircleColoredButton!
    @IBAction func blueSchemeButtonPressed(_ sender: Any) {
        updateColorTheme(.blue)
    }
    
    @IBOutlet weak var yellowButton: CircleColoredButton!
    @IBAction func yellowSchemeButtonPressed(_ sender: Any) {
        updateColorTheme(.yellow)
    }
    
    public func setupCurrentColor(_ color: Colors) {
        switch color {
        case .green:
            greenButton.isSelected = true
            blueButton.isSelected = false
            yellowButton.isSelected = false
            greenButton.setNeedsLayout()
        case .blue:
            blueButton.isSelected = true
            greenButton.isSelected = false
            yellowButton.isSelected = false
            blueButton.setNeedsLayout()
        case .yellow:
            yellowButton.isSelected = true
            greenButton.isSelected = false
            blueButton.isSelected = false
            yellowButton.setNeedsLayout()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func updateColorTheme(_ theme: Colors) {
        selectedColorScheme = theme
        setupCurrentColor(theme)
        colorButtonsTapHandler?(theme)
    }
    
}
