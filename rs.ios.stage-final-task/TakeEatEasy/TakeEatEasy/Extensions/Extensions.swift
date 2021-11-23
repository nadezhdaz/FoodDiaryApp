//
//  Extensions.swift
//  TakeEatEasy
//
//  Created by Nadezhda Zenkova on 10.11.2021.
//

import UIKit

extension UIScreen {
    
    static var isPortrait: Bool {
        main.bounds.width < main.bounds.height
    }
}

extension UIImage {
    
    var toData: Data? {
        return pngData()
    }
}

extension Sequence {
    func limit(_ max: Int) -> [Element] {
        return self.enumerated()
            .filter { $0.offset < max }
            .map { $0.element }
    }
}

extension UICollectionView {
    func register<Cell: UICollectionViewCell>(cellType: Cell.Type, nib: Bool = true) {
        let reuseIdentifier = String(describing: cellType)
        
        if nib {
            let nib = UINib(nibName: reuseIdentifier, bundle: nil)
            register(nib, forCellWithReuseIdentifier: reuseIdentifier)
        } else {
            register(cellType, forCellWithReuseIdentifier: reuseIdentifier)
        }
    }
    
    func dequeueCell<Cell: UICollectionViewCell>(of cellType: Cell.Type, for indexPath: IndexPath) -> Cell? {
        return dequeueReusableCell(withReuseIdentifier: String(describing: cellType), for: indexPath) as? Cell
    }
}

extension UIViewController {
    func showAlertWithError(message: String) {
        
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: UIAlertController.Style.alert)
        let cancel = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        
        alertController.addAction(cancel)
        
        if self.presentedViewController == nil {
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

extension Data {
    mutating func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
