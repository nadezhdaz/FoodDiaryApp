//
//  HistoryViewController.swift
//  TakeEatEasy
//
//  Created by Nadezhda Zenkova on 03.11.2021.
//

import UIKit

class HistoryViewController: UIViewController, HistoryViewModelViewDelegate {

    @IBOutlet weak var historyCollectionView: UICollectionView!
    
    var viewModel: HistoryViewModelType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDelegate = self
        viewModel.start()
        setupCollectionView()
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setupCollectionView() {
        historyCollectionView.dataSource = self
        historyCollectionView.delegate = self
        historyCollectionView.register(cellType: MealCollectionViewCell.self)
        historyCollectionView.register(cellType: MealPlaceholderCollectionViewCell.self)
        historyCollectionView.backgroundColor = .clear
        historyCollectionView.translatesAutoresizingMaskIntoConstraints = false
        historyCollectionView.reloadData()
    }
    
    // MARK: - HomeViewModelViewDelegate
    
    func updateScreen() {
        DispatchQueue.main.async {
            self.historyCollectionView.reloadData()
            self.historyCollectionView.layoutIfNeeded()
        }
    }


    func showError(_ message: String) {
        showAlertWithError(message: message)
    }
    
    func showMealPlaceholder() {
        
    }

}

extension HistoryViewController: UICollectionViewDataSource {
    
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
            guard let item = viewModel.itemFor(row: indexPath.row) else { return UICollectionViewCell() }
            cell.configure(meal: item)
            return cell
        }
    }
}

extension HistoryViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectRow(indexPath.row, from: self)
    }
}

extension HistoryViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIScreen.isPortrait
            ? UIEdgeInsets(top: 30, left: 0, bottom: 30, right: 0)
            : UIEdgeInsets(top: 40, left: 80, bottom: 40, right: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat
        let height: CGFloat
        
        if UIScreen.isPortrait {
            width = UIScreen.main.bounds.width * 0.89
            height = width * 0.66
        } else {
            width = UIScreen.main.bounds.width * 0.5
            height = width * 0.66
        }
        return CGSize(width: width, height: height)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        historyCollectionView?.collectionViewLayout.invalidateLayout();
    }
    
}
