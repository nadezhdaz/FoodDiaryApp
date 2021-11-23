//
//  HomeViewController.swift
//  TakeEatEasy
//
//  Created by Nadezhda Zenkova on 03.11.2021.
//

import UIKit

class HomeViewController: UIViewController, HomeViewModelViewDelegate {
    
    @IBOutlet weak var firstTagButton: TagButton!
    @IBOutlet weak var secondTagButton: TagButton!
    @IBOutlet weak var thirdTagButton: TagButton!
    @IBOutlet weak var noTagsLabel: UILabel!
    @IBOutlet weak var recentMealCollectionView: UICollectionView!
    
    var viewModel: HomeViewModelType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDelegate = self
        bind()
        viewModel.start()
        //viewModel.loadData()
        setupCollectionView()
        navigationController?.navigationBar.isHidden = true
    }
    
    func setTags() {
        let tags = viewModel.getTags()
        let buttons = [firstTagButton, secondTagButton, thirdTagButton]
        var i = 0
        for tag in tags {
            buttons[i]?.setTitle(tag, for: .normal)
            buttons[i]?.titleLabel?.sizeToFit()
            i += 1
        }
    }
    
    private func setupCollectionView() {
        recentMealCollectionView.dataSource = self
        recentMealCollectionView.delegate = self
        recentMealCollectionView.register(cellType: MealCollectionViewCell.self)
        recentMealCollectionView.register(cellType: MealPlaceholderCollectionViewCell.self)
        recentMealCollectionView.backgroundColor = .clear
        recentMealCollectionView.translatesAutoresizingMaskIntoConstraints = false
        recentMealCollectionView.reloadData()
    }
    
    // MARK: - HomeViewModelViewDelegate
    
    func updateScreen() {
        DispatchQueue.main.async {
            self.recentMealCollectionView.reloadData()
            self.recentMealCollectionView.layoutIfNeeded()
        }
    }
    
    func showTagsPlaceholder() {
        noTagsLabel.isHidden = false
        firstTagButton.isHidden = true
        secondTagButton.isHidden = true
        thirdTagButton.isHidden = true
    }
    
    func showMealPlaceholder() {
        
    }
    
    func showError(_ message: String) {
        showAlertWithError(message: message)
    }
    
    private func bind() {
        viewModel.dataWasReceived = { [weak self] in
            DispatchQueue.main.async {
                self?.recentMealCollectionView.reloadData()
                self?.recentMealCollectionView.layoutIfNeeded()
            }
        }
    }


}

extension HomeViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if viewModel.shouldShowMealPlaceholder {
            guard let cell = collectionView.dequeueCell(of: MealPlaceholderCollectionViewCell.self, for: indexPath) else { return UICollectionViewCell() }
            viewModel.getFoodPlaceholder(completion: { url in
                cell.configure(with: url)
            })
            return cell
        } else {
            guard let cell = collectionView.dequeueCell(of: MealCollectionViewCell.self, for: indexPath) else { return UICollectionViewCell() }
            guard let item = viewModel.itemForMeal(row: indexPath.row) else { return UICollectionViewCell() }
            cell.configure(meal: item)
            return cell
        }
    }
}

extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectRow(indexPath.row, from: self)
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 20.0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width * 0.89
        let height = width * 0.66
        return CGSize(width: width, height: height)
    }
}
