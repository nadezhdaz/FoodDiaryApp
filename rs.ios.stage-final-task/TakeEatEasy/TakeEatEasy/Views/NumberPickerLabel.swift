//
//  NumberPickerLabel.swift
//  TakeEatEasy
//
//  Created by Nadezhda Zenkova on 17.11.2021.
//

import UIKit

class NumberPickerLabel: UILabel {
    
    private let _inputView: UIView? = {
        let picker = UIDatePicker()
        return picker
    }()
    
    private let _inputAccessoryToolbar: UIToolbar = {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        
        toolBar.sizeToFit()
        
        return toolBar
    }()
    
    override var inputView: UIView? {
        return _inputView
    }
    
    override var inputAccessoryView: UIView? {
        return _inputAccessoryToolbar
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        isUserInteractionEnabled = true
        //canBecomeFirstResponder = true
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(donePressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        _inputAccessoryToolbar.setItems([ spaceButton, doneButton], animated: false)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(launchPicker))
        self.addGestureRecognizer(tapRecognizer)
    }
    
    @objc private func launchPicker() {
        becomeFirstResponder()
    }
    
    @objc private func donePressed() {
        resignFirstResponder()
    }
    
}
