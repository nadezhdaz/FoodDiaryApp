//
//  MealEditorViewController.swift
//  TakeEatEasy
//
//  Created by Nadezhda Zenkova on 04.11.2021.
//

import UIKit
import WSTagsField
import TGPControls

struct Platform {
    
    static var isSimulator: Bool {
        return TARGET_OS_SIMULATOR != 0
    }
    
}

class MealEditorViewController: UIViewController, UITextFieldDelegate, MealEditorViewModelViewDelegate {

    @IBOutlet weak var foodPictureImageView: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var moodCamelLabels: TGPCamelLabels!
    @IBOutlet weak var moodSlider: TGPDiscreteSlider!
    @IBOutlet weak var moodAfterSlider: TGPDiscreteSlider!
    @IBOutlet weak var moodAfterCamelLabels: TGPCamelLabels!
    @IBOutlet weak var saveButton: RoundButton!
    @IBOutlet weak var addFromCameraButton: TagButton!
    @IBOutlet weak var addFromPhotoLibraryButton: TagButton!
    @IBOutlet weak var confirmTagsLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tagsView: UIView!
    
    private lazy var customTagsField: WSTagsField = {
        let tagsField = WSTagsField()
        tagsField.translatesAutoresizingMaskIntoConstraints = false
        tagsField.layoutMargins = UIEdgeInsets(top: 2, left: 6, bottom: 2, right: 6)
        tagsField.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        tagsField.spaceBetweenLines = 5.0
        tagsField.spaceBetweenTags = 10.0
        tagsField.font = UIFont(name: "Lato-Regular", size: 17.0) ?? .systemFont(ofSize: 17.0)
        tagsField.backgroundColor = .white
        tagsField.tintColor = .white
        tagsField.borderColor = .darkGreen
        tagsField.borderWidth = 2.0
        tagsField.textColor = .darkGreen
        tagsField.textField.textColor = .darkGreen
        tagsField.selectedColor = .darkGreen
        tagsField.selectedTextColor = .white
        tagsField.delimiter = ","
        tagsField.placeholderAlwaysVisible = false
        tagsField.placeholder = ""
        tagsField.isDelimiterVisible = false
        tagsField.placeholderColor = .darkGreen
        tagsField.placeholderAlwaysVisible = true
        tagsField.keyboardAppearance = .dark
        tagsField.textField.returnKeyType = .next
        tagsField.acceptTagOption = .space
        tagsField.shouldTokenizeAfterResigningFirstResponder = true
        return tagsField
    }()
    
    private var moodValue: Int32?
    private var moodAfterValue: Int32?
    
    @IBAction func addFromCameraTapped(_ sender: Any) {
        imagePicker.cameraAsscessRequest()
    }
    
    @IBAction func addFromPhotoLibraryTapped(_ sender: Any) {
        imagePicker.photoGalleryAsscessRequest()
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveAndCloseButtonTapped(_ sender: Any) {
        let name = nameTextField.text
        let date = viewModel.date
        let image = foodPictureImageView.image ?? UIImage()
        let tags = customTagsField.tags.map({$0.text})
        let mood = moodValue ?? 3
        let moodAfter = moodAfterValue ?? 3
        viewModel.saveMealValues(name: name, date: date, image: image, tags: tags, mood: mood, moodAfter: moodAfter)
        dismiss(animated: true, completion: nil)
    }
    
    var viewModel: MealEditorViewModelType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDelegate = self
        viewModel.start()
        setupTextFields()
        setupTagsfield()
        setupSliders()
        addFromCameraButton.isEnabled = Platform.isSimulator ? false : true
    }
    
    private func setupTextFields() {
        dateTextField.setInputViewDatePicker(target: self, selector: #selector(dateTapDone))
        dateTextField.delegate = self
    }
    
    private func setupSliders() {
        moodSlider.addTarget(self,action: #selector(moodValueChanged(_:event:)),for: .valueChanged)
        moodCamelLabels.names = ["Awful", "Bad", "Could be better", "Cool", "Awesome"]
        moodSlider.ticksListener = moodCamelLabels
        
        moodAfterSlider.addTarget(self,action: #selector(moodAfterValueChanged(_:event:)),for: .valueChanged)
        moodAfterCamelLabels.names = ["Awful", "Bad", "Could be better", "Cool", "Awesome"]
        moodAfterSlider.ticksListener = moodAfterCamelLabels
    }


    @objc private func dateTapDone() {
        if let datePicker = self.dateTextField.inputView as? UIDatePicker {
            self.dateTextField.text = datePicker.date.defaultDateToString()
            viewModel.date = datePicker.date
        }
        self.dateTextField.resignFirstResponder()
    }
    
    private lazy var imagePicker: ImagePickerService = {
        let imagePicker = ImagePickerService()
        imagePicker.delegate = self
        return imagePicker
    }()
    
    private func setupTagsfield() {
        tagsView.addSubview(customTagsField)
        customTagsField.layer.cornerRadius = 8.0
        
        NSLayoutConstraint.activate([
            customTagsField.topAnchor.constraint(equalTo: tagsView.topAnchor),
            customTagsField.leadingAnchor.constraint(equalTo: tagsView.leadingAnchor),
            customTagsField.trailingAnchor.constraint(equalTo: tagsView.trailingAnchor),
            customTagsField.bottomAnchor.constraint(equalTo: tagsView.bottomAnchor)
        ])
        
        customTagsField.onValidateTag = { tag, tags in            
            return tag.text != "#" && !tags.contains(where: { $0.text.uppercased() == tag.text.uppercased() })
        }
    }
    
    @objc private func moodValueChanged(_ sender: TGPDiscreteSlider, event: UIEvent) {
        moodValue = Int32(sender.value)
    }
    
    @objc private func moodAfterValueChanged(_ sender: TGPDiscreteSlider, event: UIEvent) {
        moodAfterValue = Int32(sender.value)
    }
    
    func updateScreen() {
        
    }
    
    func updateMeal(with meal: MealModel) {
        foodPictureImageView.image = meal.picture
        dateTextField.text = meal.date.defaultDateToString()
        customTagsField.addTags(meal.tagStrings ?? [])
        nameTextField.text = meal.name
        moodSlider.value = CGFloat(meal.mood?.rawValue ?? 3)
        moodAfterSlider.value = CGFloat(meal.moodAfter?.rawValue ?? 3)
    }
    
    func showError(_ message: String) {
        showAlertWithError(message: message)
    }
    
}

// MARK: ImagePickerDelegate

extension MealEditorViewController: ImagePickerDelegate {
    
    func imagePicker(_ imagePicker: ImagePickerService, didSelect image: UIImage) {
        foodPictureImageView.image = image
        viewModel.getTagsFor(image: image, completion: { [weak self] tagModels in
            var tagStrings: [String] = []
            if let models = tagModels {
                for model in models {
                    tagStrings.append(model.tag)
                    self?.customTagsField.addTags(tagStrings)
                }
            }
            
        })
        imagePicker.dismiss()
    }
    
    func cancelButtonDidClick(on imageView: ImagePickerService) { imagePicker.dismiss() }
    func imagePicker(_ imagePicker: ImagePickerService, grantedAccess: Bool,
                     to sourceType: UIImagePickerController.SourceType) {
        guard grantedAccess else { return }
        imagePicker.present(parent: self, sourceType: sourceType)
    }
}
