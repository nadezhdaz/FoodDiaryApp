//
//  RaisedButtonTabbar.swift
//  TakeEatEasy
//
//  Created by Nadezhda Zenkova on 08.11.2021.
//

import UIKit

protocol RaisedTabbarButtonDelegate {
    func didTapRaisedButton()
}

class RaisedButtonTabbar: UITabBar {
    
    // MARK: - Variables
    public var didTapButton: (() -> ())?
    
    public var presentingDelegate: RaisedTabbarButtonDelegate?
    
    public lazy var middleButton: BigPlusButton! = {
        let middleButton = BigPlusButton()
        middleButton.addTarget(self, action: #selector(self.middleButtonAction), for: .touchUpInside)
        addSubview(middleButton)
        return middleButton
    }()
    
    // MARK: - View Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.shadowColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1).cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.layer.shadowRadius = 4.0
        self.layer.shadowOpacity = 0.4
        self.layer.masksToBounds = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            
            middleButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            middleButton.topAnchor.constraint(equalTo: topAnchor, constant: -30)
        ])
    }
    
    // MARK: - Actions
    @objc func middleButtonAction(sender: UIButton) {
        presentingDelegate?.didTapRaisedButton()
    }
    
    // MARK: - HitTest
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard !clipsToBounds && !isHidden && alpha > 0 else { return nil }
        
        return self.middleButton.frame.contains(point) ? self.middleButton : super.hitTest(point, with: event)
    }

}
