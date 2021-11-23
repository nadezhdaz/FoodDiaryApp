//
//  OnboardingSlide.swift
//  TakeEatEasy
//
//  Created by Nadezhda Zenkova on 04.11.2021.
//

import UIKit

class OnboardingSlide: UIView {

    @IBOutlet weak var hiLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var startButton: RoundButton!
    
    private var height = CGFloat(300.0)
    private var width = CGFloat(375.0)
    
    @IBAction func startAction(_ sender: Any) {
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func loadNib() -> OnboardingSlide {
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! OnboardingSlide
    }
    
    public func hideHiLabel() {
        hiLabel.isHidden = true
    }
    
    public func setWidth(_ width: CGFloat, height: CGFloat) {
        self.width = CGFloat(width)
        self.height = CGFloat(height)
    }
    
    public func setDescription(_ text: String) {
        descriptionLabel.text = text
    }
    
    public func showStartButton() {
        startButton.isHidden = false
    }
    
    
    private func setupUI() {
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: height),
            widthAnchor.constraint(equalToConstant: width)
        ])
        
        roundTopCorners(cornerRadius: 24.0)
        backgroundColor = .backgroundSecondaryColor
        
        startButton.isHidden = true
        
        startButton.backgroundColor = .darkGreen
        startButton.titleLabel?.textColor = .buttonTextColor
    }
    
    private func roundTopCorners(cornerRadius: Double) {
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.clipsToBounds = true
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
}
