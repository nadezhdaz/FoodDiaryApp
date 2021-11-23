//
//  OnboardingLabelCell.swift
//  TakeEatEasy
//
//  Created by Nadezhda Zenkova on 05.11.2021.
//

import UIKit

class OnboardingLabelCell: UICollectionViewCell {
    
    // MARK: - SubViews
    
    private var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .defaultTextColor
        label.font = UIFont(name: "Lato-Regular", size: 17.0) ?? .systemFont(ofSize: 17.0)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.widthAnchor.constraint(equalToConstant: 310.0).isActive = true
        return label
    }()
    
    // MARK: - Properties
    
    static let cellId = "OnboardingLabelCell"
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - Setups
    
    func setupUI() {
        backgroundColor = .clear
        
        addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    // MARK: - Public
    
    public func configure(text: String) {
        label.text = text
    }
    
}
