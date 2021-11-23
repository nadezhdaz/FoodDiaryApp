//
//  BigPlusButton.swift
//  TakeEatEasy
//
//  Created by Nadezhda Zenkova on 09.11.2021.
//

import UIKit

class BigPlusButton: UIButton {
    
    private let buttonDiameter: CGFloat = UIScreen.isPortrait ? 75.0 : 60.0
    
    private lazy var plusImageView: UIImageView = {
        let plusImageView = UIImageView()
        plusImageView.image = UIImage(systemName: "plus")
        plusImageView.tintColor = UIColor.lightGray
        plusImageView.translatesAutoresizingMaskIntoConstraints = false
        return plusImageView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            
            heightAnchor.constraint(equalToConstant: buttonDiameter),
            widthAnchor.constraint(equalToConstant: buttonDiameter)
        ])
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    override open var isHighlighted: Bool {
        didSet {
            plusImageView.tintColor = isHighlighted ? UIColor.lightGray.withAlphaComponent(0.5) : UIColor.lightGray
        }
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if self.point(inside: point, with: event) {
            isHighlighted = true
            return self
        }
        return super.hitTest(point, with: event)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        NSLayoutConstraint.activate([
            
            heightAnchor.constraint(equalToConstant: buttonDiameter),
            widthAnchor.constraint(equalToConstant: buttonDiameter)
        ])
    }
    
    private func setupButton() {
        layer.cornerRadius = buttonDiameter / 2
        backgroundColor = .coral
        clipsToBounds = true
        layer.shadowColor = UIColor.coral.withAlphaComponent(0.25).cgColor
        layer.shadowRadius = 15.0
        layer.shadowOpacity = 1.0
        layer.shadowOffset = CGSize(width: 0, height: 6.0)
        layer.masksToBounds = false
        
        frame.size = CGSize(width: 75.0, height: 75.0)
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(plusImageView)
        
        let buttonDiameter: CGFloat = UIScreen.isPortrait ? 75.0 : 60.0
        
        NSLayoutConstraint.activate([
            
            heightAnchor.constraint(equalToConstant: buttonDiameter),
            widthAnchor.constraint(equalToConstant: buttonDiameter)
        ])
        
        
        NSLayoutConstraint.activate([
            
            plusImageView.heightAnchor.constraint(equalToConstant: 30),
            plusImageView.widthAnchor.constraint(equalToConstant: 30),
            
            plusImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            plusImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
}
