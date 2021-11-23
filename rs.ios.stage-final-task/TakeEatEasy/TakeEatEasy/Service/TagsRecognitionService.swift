//
//  TagsRecognitionService.swift
//  TakeEatEasy
//
//  Created by Nadezhda Zenkova on 09.11.2021.
//

import UIKit

protocol TagsRecognitionService {
    
    typealias TagsResult = (Result<[TagModel], EveryPixelNetworkError>) -> Void
    
    func getTags(for image: UIImage, accuracy: Float, completion: @escaping TagsResult)
    
}

class TagsRecognitionApiService {
    
    private let apiClient: EveryPixelApiClientType
    private var imageCounter = 1
    private var imageName = ""
    private var excludedTags = ["food", "plate", "gourmet", "close-up", "freshness", "meal", "vegetarian food", "healthy eating", "organic", "bowl", "green color", "nature"]
    
    // MARK: - Init
    init(apiClient: EveryPixelApiClientType) {
        self.apiClient = apiClient
        self.imageName = "image_\(imageCounter).jpg"
        
        self.apiClient.start()
    }
    
}

// MARK: - API
extension TagsRecognitionApiService: TagsRecognitionService {
    func getTags(for image: UIImage, accuracy: Float, completion: @escaping TagsResult) {
        let image = image
        
        apiClient.getTagsRequest(image: image, imageName: imageName, accuracy: accuracy, completion: { result in
            switch result {
            case .success(let tags):
                self.imageCounter += 1
                let validatedTags = tags.filter { !self.excludedTags.contains($0.tag) }
                completion(.success(validatedTags))
            case .failure(let error):
                self.imageCounter += 1
                completion(.failure(error))
            }
        })
    }
}
