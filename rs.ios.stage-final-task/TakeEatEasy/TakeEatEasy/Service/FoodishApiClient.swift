//
//  FoodishApiClient.swift
//  TakeEatEasy
//
//  Created by Nadezhda Zenkova on 09.11.2021.
//

import Foundation

enum FoodishNetworkError: Error {
    case badRequest
}

extension FoodishNetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .badRequest:
            return NSLocalizedString("Image url not found", comment: "Foodish Network Error")
        }
    }
}

protocol FoodishApiClientType {
    func getPlaceholderRequest(completion: @escaping (Result<FoodPlaceholderModel, FoodishNetworkError>) -> Void)
}

class FoodishApiClient: FoodishApiClientType {
    
    //
    // MARK: - Constants
    //
    
    private let defaultSession = URLSession(configuration: .default)
    private let defaultAPIstringURL = "https://foodish-api.herokuapp.com/"
    private let scheme = "https"
    private let host = "foodish-api.herokuapp.com"
    private let hostPath = "https://foodish-api.herokuapp.com"
    private let imagesPath = "/api"
    
    // MARK: - Type Alias
    //
    
    public typealias PlaceholderResult = (Result<FoodPlaceholderModel, FoodishNetworkError>) -> Void
    
    //
    // MARK: - Public Methods
    //
    
    public func getPlaceholderRequest(completion: @escaping PlaceholderResult) {
        guard let request = placeholderUrlRequest() else { return }
        
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            
            if let data = data,
                let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) {
                guard let imageUrl = self.parseFoodPlaceholder(data) else { return }
                completion(.success(imageUrl))
            } else {
                completion(.failure(.badRequest))
            }
            
        }
        
        task.resume()
    }
    
    //
    // MARK: - Private Methods
    //
    
    private func placeholderUrlRequest() -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = imagesPath
        
        guard let url = urlComponents.url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accepts")
        
        return request
    }
    
    private func parseFoodPlaceholder(_ data: Data) -> FoodPlaceholderModel? {
        do {
            let decoder = JSONDecoder()
            let randomImage = try decoder.decode(FoodPlaceholderModel.self, from: data)
            return randomImage
        } catch {
            debugPrint(error)
            print("JSONDecoder error: \(error.localizedDescription)\n")
            return nil
        }
    }
}
