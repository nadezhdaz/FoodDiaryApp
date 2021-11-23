//
//  NumberSettingsTableViewCell.swift
//  TakeEatEasy
//
//  Created by Nadezhda Zenkova on 17.11.2021.
//

import UIKit

class NumberSettingsTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let cellId = "NumberSettingsTableViewCell"
    
    private var currentAccuracy: Float?
    
    public var accuracyButtonTapHandler: ((Float) -> Void)?

    @IBOutlet weak var numberLabel: UILabel!
    //@IBOutlet weak var numberLabel: NumberPickerLabel!
    
    @IBOutlet weak var stepper: UIStepper!
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        let value = Float(sender.value / 10.0)
        numberLabel.text = "\(value)"
        currentAccuracy = value
        
        accuracyButtonTapHandler?(value)
    }
    
    public func setupNumber(_ number: Float) {
        let value = Double(number * 10.0)
        stepper.value = value
        numberLabel.text = "\(number)"
        currentAccuracy = number
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
