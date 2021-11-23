//
//  CircleColoredButton.swift
//  TakeEatEasy
//
//  Created by Nadezhda Zenkova on 17.11.2021.
//

import UIKit

class CircleColoredButton: UIButton {
    
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
    
    override open var isSelected: Bool {
        willSet {
            layer.borderWidth = isSelected ? 1.0 : 0.0
        }
        didSet {
            layer.borderWidth = isSelected ? 1.0 : 0.0
        }
    }
    
    func setupButton() {
        layer.masksToBounds = false
        layer.cornerRadius = frame.width / 2
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        layer.borderColor = UIColor.onboardingTextColor.cgColor 
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 30.0),
            widthAnchor.constraint(equalToConstant: 30.0)
        ])
    }
    
}
