//
//  LoadingImageView.swift
//  TakeEatEasy
//
//  Created by Nadezhda Zenkova on 11.11.2021.
//

import UIKit

class LoadingImageView: UIImageView {
    
    // MARK: - Initializers
    
    // MARK: - Properties
    
    public var imageCache = NSCache<AnyObject, AnyObject>()
    var imageURL: URL?
    
    let activityIndicator = UIActivityIndicatorView()
    override func awakeFromNib() {
        super.awakeFromNib()
        imageCache = NSCache<AnyObject, AnyObject>()
        imageCache.countLimit = 50  // number of objects
        imageCache.totalCostLimit = 100 * 1024 * 1024  // max 100MB used
    }
    
    // MARK: - Public Methods    
    
    public func loadImageWithUrl(_ url: URL) { //}, mode: UIIViewContentMode = .scaleAspectFit) {
        
        activityIndicator.color = .darkGray
        addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        imageURL = url
        image = nil
        
        activityIndicator.startAnimating()
        
        if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage {
            self.image = imageFromCache
            
            activityIndicator.stopAnimating()
            return
        }
        
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            
            if let error = error {
                
                print(error)
                
                DispatchQueue.main.async(execute: {
                    self.activityIndicator.stopAnimating()
                })
                
                return
            }
            
            DispatchQueue.main.async(execute: {
                if let unwrappedData = data, let imageToCache = UIImage(data: unwrappedData) {
                    if self.imageURL == url {
                        self.image = imageToCache
                    }
                    
                    self.imageCache.setObject(imageToCache, forKey: url as AnyObject)
                    
                }
                
                self.activityIndicator.stopAnimating()
                
            })
            
        }).resume()
        
    }
    
}

