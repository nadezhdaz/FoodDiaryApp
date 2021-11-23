//
//  FoodPlaceholderApiService.swift
//  TakeEatEasy
//
//  Created by Nadezhda Zenkova on 09.11.2021.
//

import Foundation

protocol FoodPlaceholderService {
    
    var imageUrls: [String] { get }
    var error: FoodishNetworkError? { get set }
    
    typealias PlaceholderResult = (Result<FoodPlaceholderModel, FoodishNetworkError>) -> Void
    typealias PlaceholdersResult = (Result<[FoodPlaceholderModel], FoodishNetworkError>) -> Void
    
    //func getFoodImage(completion: @escaping PlaceholderResult)
    func getFoodImage(completion: @escaping (FoodPlaceholderModel?, FoodishNetworkError?) -> ())
    
}

class FoodPlaceholderApiService {
    
    private let apiClient: FoodishApiClientType
    
    var imageUrls: [String] = []
    
    var error: FoodishNetworkError?
    
    // MARK: - Init
    init(apiClient: FoodishApiClientType) {
        self.apiClient = apiClient
    }
    
}

// MARK: - API
extension FoodPlaceholderApiService: FoodPlaceholderService {
    
    func getFoodImage(completion: @escaping (FoodPlaceholderModel?, FoodishNetworkError?) -> ()) {
        
        apiClient.getPlaceholderRequest(completion: { result in
            switch result {
            case .success(let imageUrl):
                completion(imageUrl, nil)
            case .failure(let error):
                completion(nil, error)
            }
        })
    }
    
}
