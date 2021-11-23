//
//  MealEditorViewModel.swift
//  TakeEatEasy
//
//  Created by Nadezhda Zenkova on 11.11.2021.
//

import UIKit

//var minimumScore = 0.5

protocol MealEditorViewModelType {
    
    // Data Source
    
    var date: Date? { get set }
    
    var minimumScore: Float { get }
    
    func saveMealValues(name: String?, date: Date?, image: UIImage?, tags: [String], mood: Int32, moodAfter: Int32)
    
    func updateMeal(_ mealModel: MealModel)
    
    func getTagsFor(image: UIImage, completion: @escaping ([TagModel]?) -> Void)
    
    // Events
    
    func start()
    
    func didSelectClose()
    
    var viewDelegate: MealEditorViewModelViewDelegate? { get set }
    
}

protocol MealEditorViewModelCoordinatorDelegate: class {
    
    func reloadDataChanges()
    
    func didSelectClose(from viewModel: MealEditorViewModel, from controller: MealEditorViewModelViewDelegate)
    
}

protocol MealEditorViewModelViewDelegate: class {
    
    func updateScreen()
    
    func updateMeal(with meal: MealModel)
    
    func showError(_ message: String)
    
    //func updateState(_ state: ViewControllerState)
    
}

class MealEditorViewModel {
    
    // MARK: - Delegates
    weak var coordinatorDelegate: MealEditorViewModelCoordinatorDelegate?
    
    weak var viewDelegate: MealEditorViewModelViewDelegate?
    
    // MARK: - Properties
    
    fileprivate let image: UIImage?
    
    fileprivate let service: TagsRecognitionApiService
    fileprivate let datasource: CoreDataServiceType
    fileprivate let defaults: UserDefaultsDataServiceType
    
    fileprivate var currentMeal: MealModel?
    
    fileprivate var loadedTags: [TagModel]?
    
    fileprivate var isAnyMealLogged = false
    
    fileprivate var isAnyTagAdded = false
    
    public var date: Date?
    
    private var accuracy: Float
    
    // MARK: - Init
    init(meal: MealModel?, service: TagsRecognitionApiService, datasource: CoreDataServiceType, defaults: UserDefaultsDataServiceType) {
        self.currentMeal = meal
        self.image = meal?.picture ?? UIImage()
        self.service = service
        self.datasource = datasource
        self.defaults = defaults
        //self.coordinatorDelegate = delegate
        
        self.accuracy = defaults.fetchTagAccuracy()
    }
    
    func start() {
        loadMeal()
    }
    
    private func loadMeal() {
        if let meal = currentMeal {
            viewDelegate?.updateMeal(with: meal)
        }
    }
    
    // MARK: - Network
    
    func getTags() {
        guard let image = image else { return }
        service.getTags(for: image, accuracy: accuracy, completion: { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let tags):
                    self?.loadedTags = tags
                    self?.viewDelegate?.updateScreen()
                    
                case .failure(let error):
                    self?.viewDelegate?.showError(error.localizedDescription)
                }
            }
        })
        
    }
    
}

extension MealEditorViewModel: MealEditorViewModelType {
    
    func saveMealValues(name: String?, date: Date?, image: UIImage?, tags: [String], mood: Int32, moodAfter: Int32) {
        if currentMeal != nil {
            currentMeal?.name = name
            currentMeal?.date = date ?? Date()
            currentMeal?.picture = image ?? UIImage()
            currentMeal?.tagStrings = tags
            currentMeal?.mood = MoodModel(rawValue: mood)
            currentMeal?.moodAfter = MoodModel(rawValue: moodAfter)
            if currentMeal != nil {
                datasource.changeMeal(mealModel: currentMeal!)
            }
        } else {
            let newMeal = MealModel(name: name, date: date ?? Date(), picture: image ?? UIImage(), tagStrings: tags, mood: MoodModel(rawValue: mood), moodAfter: MoodModel(rawValue: moodAfter))
            datasource.addNewMeal(mealModel: newMeal)
        }
        didSelectClose()
    }
    
    func getTagsFor(image: UIImage, completion: @escaping ([TagModel]?) -> Void) {
        service.getTags(for: image, accuracy: accuracy, completion: { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let tags):
                    self?.loadedTags = tags
                    self?.viewDelegate?.updateScreen()
                    completion(tags)
                case .failure(let error):
                    self?.viewDelegate?.showError(error.localizedDescription)
                    completion(nil)
                }
            }
        })
    }
    var minimumScore: Float {
        return defaults.fetchTagAccuracy()
    }
    
    
    // MARK: - Data Source
    
    func updateMeal(_ mealModel: MealModel) {
        datasource.changeMeal(mealModel: mealModel)
    }
    
    // MARK: - Events
    
    func didSelectClose() {
        guard let delegateController = viewDelegate else { return }
        guard let coordinator = coordinatorDelegate else { return }
        coordinator.didSelectClose(from: self, from: delegateController)
    }
    
}
