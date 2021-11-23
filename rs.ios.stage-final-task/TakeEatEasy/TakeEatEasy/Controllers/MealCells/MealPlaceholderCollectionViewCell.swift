//
//  MealPlaceholderCollectionViewCell.swift
//  TakeEatEasy
//
//  Created by Nadezhda Zenkova on 10.11.2021.
//

import UIKit

class MealPlaceholderCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var firstImageView: LoadingImageView!
    @IBOutlet weak var secondImageView: LoadingImageView!
    @IBOutlet weak var thirdImageView: LoadingImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    public func configure(with imageUrl: String) {
        let imageViews = [firstImageView, secondImageView, thirdImageView]
        for view in imageViews {
            view?.loadImageWithUrl(URL(string: imageUrl)!)
        }
    }

}
