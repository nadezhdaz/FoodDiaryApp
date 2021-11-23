//
//  ImagePickerController.swift
//  TakeEatEasy
//
//  Created by Nadezhda Zenkova on 14.11.2021.
//

import UIKit

class ImagePickerController: UIViewController {
    
    @objc func photoButtonTapped(_ sender: UIButton) { imagePicker.photoGalleryAsscessRequest() }
    @objc func cameraButtonTapped(_ sender: UIButton) { imagePicker.cameraAsscessRequest() }
    
    @IBOutlet weak var chosenImageView: UIImageView!
    @IBOutlet weak var imageView: UIImageView!
    private lazy var imagePicker: ImagePickerService = {
        let imagePicker = ImagePickerService()
        imagePicker.delegate = self
        return imagePicker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "camera", style: .plain, target: self,
                                                           action: #selector(cameraButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "photo", style: .plain, target: self,
                                                            action: #selector(photoButtonTapped))
        
        let imageView = UIImageView(frame: CGRect(x: 40, y: 80, width: 200, height: 200))
        imageView.backgroundColor = .lightGray
        view.addSubview(imageView)
        self.imageView = imageView
    }
    
}

// MARK: ImagePickerDelegate

extension ImagePickerController: ImagePickerDelegate {
    
    func imagePicker(_ imagePicker: ImagePickerService, didSelect image: UIImage) {
        imageView.image = image
        imagePicker.dismiss()
    }
    
    func cancelButtonDidClick(on imageView: ImagePickerService) { imagePicker.dismiss() }
    func imagePicker(_ imagePicker: ImagePickerService, grantedAccess: Bool,
                     to sourceType: UIImagePickerController.SourceType) {
        guard grantedAccess else { return }
        imagePicker.present(parent: self, sourceType: sourceType)
    }
}
