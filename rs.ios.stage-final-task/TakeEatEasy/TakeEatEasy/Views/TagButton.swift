//
//  TagButton.swift
//  TakeEatEasy
//
//  Created by Nadezhda Zenkova on 10.11.2021.
//

import UIKit

class TagButton: UIButton {
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if self.point(inside: point, with: event) {
            isHighlighted = true
            return self
        }
        return super.hitTest(point, with: event)
    }
    
    func setupButton() {
        backgroundColor = .clear
        titleLabel?.textColor = .darkGreen
        tintColor = .darkGreen//.mainLabelColor
        titleLabel?.font = UIFont(name: "Lato-SemiBold", size: 14)
        layer.masksToBounds = false
        layer.cornerRadius = 8.0
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.tagBorderColor.cgColor
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        NSLayoutConstraint.activate([
            //heightAnchor.constraint(equalToConstant: 22.0),
            //widthAnchor.constraint(equalToConstant: 93.0)
        ])
    }
    
}
