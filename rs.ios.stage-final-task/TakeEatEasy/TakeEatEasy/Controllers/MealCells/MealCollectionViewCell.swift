//
//  MealCollectionViewCell.swift
//  TakeEatEasy
//
//  Created by Nadezhda Zenkova on 09.11.2021.
//

import UIKit

class MealCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var moodHeaderLabel: UILabel!
    @IBOutlet weak var moodLabel: UILabel!
    @IBOutlet weak var moodAfterHeaderLabel: UILabel!
    @IBOutlet weak var moodAfterLabel: UILabel!
    @IBOutlet weak var tagsHeaderLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    public func configure(meal: MealModel) {
        foodImageView.image = meal.picture
        dateLabel.text = meal.date.defaultDateToString()
        moodLabel.text = meal.mood?.description
        moodHeaderLabel.isHidden = moodLabel.text == nil
        moodAfterLabel.text = meal.moodAfter?.description
        moodAfterHeaderLabel.isHidden = moodAfterLabel.text == nil
        tagsLabel.text = meal.tagsList()
        tagsHeaderLabel.isHidden = tagsLabel.text == nil
    }

}
