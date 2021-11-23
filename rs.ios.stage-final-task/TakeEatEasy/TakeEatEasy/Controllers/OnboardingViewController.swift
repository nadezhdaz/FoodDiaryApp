//
//  OnboardingViewController.swift
//  TakeEatEasy
//
//  Created by Nadezhda Zenkova on 04.11.2021.
//

import UIKit

class OnboardingViewController: UIViewController, UICollectionViewDelegate {
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var hiLabel: UILabel!
    @IBOutlet weak var startButton: RoundButton!
    @IBOutlet weak var labelsCollectionView: UICollectionView!
    
    var viewModel: OnboardingViewModelType!
    
    private var currentPage = 0 {
        didSet {
            pageControl.currentPage = currentPage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        
        pageControl.numberOfPages = viewModel.slidingText.count
        pageControl.currentPage = 0
        
        //startButton.isEnabled = false
    }
    
    init(viewModel: OnboardingViewModelType) {
        super.init(nibName: "OnboardingViewController", bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func startButtonTapped(_ sender: Any) {
        viewModel.didSelectClose(from: self)
        
        //resetWindow(with: TabBarViewController())
    }
    
    private func setupCollectionView() {
        labelsCollectionView.showsHorizontalScrollIndicator = false
        labelsCollectionView.isPagingEnabled = true
        labelsCollectionView.dataSource = self
        labelsCollectionView.delegate = self
        labelsCollectionView.register(OnboardingLabelCell.self, forCellWithReuseIdentifier: OnboardingLabelCell.cellId)
        labelsCollectionView.backgroundColor = .clear
        labelsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        let carouselLayout = UICollectionViewFlowLayout()
        let width = CGFloat(310.0)
        let height = startButton.frame.minY - hiLabel.frame.maxY
        carouselLayout.scrollDirection = .horizontal
        carouselLayout.itemSize = CGSize(width: width, height: height)
        carouselLayout.minimumLineSpacing = 0
        carouselLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        labelsCollectionView.isPagingEnabled = true
        labelsCollectionView.collectionViewLayout = carouselLayout
        labelsCollectionView.reloadData()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setupCollectionView()
    }
    
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }
    
    // MARK: - Helpers
    
    func getCurrentPage() -> Int {
        let visibleRect = CGRect(origin: labelsCollectionView.contentOffset, size: labelsCollectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        if let visibleIndexPath = labelsCollectionView.indexPathForItem(at: visiblePoint) {
            return visibleIndexPath.row
        }
        return currentPage
    }
    
    // MARK: - UICollectionView Delegate
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        currentPage = getCurrentPage()
        updatePage()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        currentPage = getCurrentPage()
        updatePage()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        currentPage = getCurrentPage()
        updatePage()
    }
    
    private func updatePage() {
        let lastPage = viewModel.slidingText.count - 1
        if currentPage == lastPage {
            startButton.isEnabled = true
        }
    }

}

extension OnboardingViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.slidingText.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OnboardingLabelCell.cellId, for: indexPath) as? OnboardingLabelCell else { return UICollectionViewCell() }
        let text = viewModel.slidingText[indexPath.row]
        cell.configure(text: text)
        return cell
    }
}

private extension OnboardingViewController {
    private func resetWindow(with viewController: UIViewController?) {
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
            fatalError("Could not get scene delegate ")
        }
        sceneDelegate.window?.rootViewController = viewController
    }
}
