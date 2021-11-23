//
//  RoundButton.swift
//  TakeEatEasy
//
//  Created by Nadezhda Zenkova on 04.11.2021.
//

import UIKit

class RoundButton: UIButton {

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
        backgroundColor = .buttonBackgroundColor
        titleLabel?.textColor = .buttonTextColor
        titleLabel?.font = UIFont(name: "Lato-ExtraBold", size: 24)
        layer.masksToBounds = false
        layer.cornerRadius = 20
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        layer.shadowColor = UIColor.buttonBackgroundColor.cgColor
        layer.shadowRadius = 0
        layer.shadowOpacity = 1.0
        layer.shadowOffset = CGSize(width: 0, height: 6.0)
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 65.0),
            widthAnchor.constraint(equalToConstant: 235.0)
        ])
    }

}
