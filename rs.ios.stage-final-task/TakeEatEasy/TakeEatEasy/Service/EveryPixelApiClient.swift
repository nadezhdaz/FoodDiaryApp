//
//  EveryPixelApiClient.swift
//  TakeEatEasy
//
//  Created by Nadezhda Zenkova on 09.11.2021.
//

import UIKit

enum EveryPixelNetworkError: Error {
    case noAccess
    case exceedAvailableRequests
    case apiError(message: String)
}

struct Token: Codable {
    var token: String
    var type: String
    var scope: String
    
    enum CodingKeys: String, CodingKey {
        case token = "access_token"
        case type = "token_type"
        case scope
    }
}

extension EveryPixelNetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noAccess:
            return NSLocalizedString("Developer has no access to a specified endpoint. It might happen if access token has been expired", comment: "401 Every Pixel Network Error")
        case .exceedAvailableRequests:
            return NSLocalizedString("Developer has exceeded available requests from plan", comment: "429 Every Pixel Network Error")
        case .apiError(message: let message):
            return NSLocalizedString(message, comment: "Every Pixel Network Error")
        }
    }
}

enum EveryPixelStatus: String {
    case ok = "ok"
    case error = "error"
}

struct EveryPixelApiErrorModel: Codable {
    var status: String
    var message: String
    
    enum CodingKeys: String, CodingKey {
        case status, message
    }
}

struct EveryPixelMessageErrorModel: Codable {
    var message: String
    
    enum CodingKeys: String, CodingKey {
        case message
    }
}

protocol EveryPixelApiClientType {
    
    func getTagsRequest(image: UIImage, imageName: String, accuracy: Float, completion: @escaping (Result<[TagModel], EveryPixelNetworkError>) -> Void)
    
    func start()
}

class EveryPixelApiClient: EveryPixelApiClientType {
    
    //
    // MARK: - Constants
    //
    
    private let clientID = "4W6PvhrpejcQ2uV8aPNtnLOD"
    private let clientSecret = "mSVrJKYPtTa1oHlqw7D1cUg54AGqux5E4y5WLCryGbCAg67t"
    private var token: String?
    
    //var dataTask: URLSessionDataTask?
    private let defaultSession = URLSession(configuration: .default)
    private let scheme = "https"
    private let host = "api.everypixel.com"
    private let hostPath = "https://api.everypixel.com"
    private let keywordsPath = "/v1/keywords"
    private let authorizationPath = "/oauth/token"
    private let apiEndpoint = "https://api.everypixel.com/v1/keywords"
    
    private let keychainService = KeychainService()
    private var tokenSaved: Bool?
    private var lastDateTokenSaved: Date?
    
    // MARK: - Type Alias
    //
    public typealias KeywordsRequestResult = [String : [TagModel]]
    
    public typealias TagsResult = (Result<[TagModel], EveryPixelNetworkError>) -> Void
    
    private typealias Parameters = [String: String]
    
    //
    // MARK: - Init
    //
    
    public func start() {
        if isTokenExpired() {
            signInSavingToken()
        }
    }
    
    //
    // MARK: - Public Methods
    //
    
    public func getTagsRequest(image: UIImage, imageName: String, accuracy: Float, completion: @escaping TagsResult) {
        
        if isTokenExpired() {
            signInSavingToken()
        }
        
        let boundary = generateBoundary()
        var uploadRequest = uploadRequestWith(boundary: boundary, accuracy: accuracy)
        
        let data = createDataBody(photo: image, fileName: imageName, boundary: boundary)
        uploadRequest?.setValue(String(data.count), forHTTPHeaderField: "Content-Length")
        
        guard let request = uploadRequest else { return }
        
        let task = URLSession.shared.uploadTask(with: request, from: data) {
            data, response, error in
            if let response = response as? HTTPURLResponse, response.statusCode == 429 {
                completion(.failure(.exceedAvailableRequests))
            } else if let response = response as? HTTPURLResponse, response.statusCode == 401 {
                completion(.failure(.noAccess))
            } else if
                let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 {
                if let status = self.parseStatus(data) {
                    switch status {
                    case .ok:
                        if let tags = self.parseTagsData(data) {
                            DispatchQueue.main.async {
                                completion(.success(tags))
                            }
                        }
                    case .error:
                        if let errorMessage = self.parseApiErrorData(data) {
                            DispatchQueue.main.async {
                                completion(.failure(.apiError(message: errorMessage)))
                            }
                        }
                    }
                    
                }
                
            } else if let httpresponse = response as? HTTPURLResponse {
                    print(httpresponse.statusCode)
                if let data = data, let errorMessage = self.parseMessageErrorData(data) {
                    DispatchQueue.main.async {
                        print(errorMessage)
                        completion(.failure(.apiError(message: errorMessage)))
                    }
                }
            }
            
        }
        
        task.resume()
    }
    
    //
    // MARK: - Private Methods
    //
    
    private func signInRequest(completion: @escaping (String?) -> Void) {
        guard let request = signInUrlRequest() else { return }
        
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            
            if let response = response as? HTTPURLResponse,
                      response.statusCode != 200 {
                completion(nil)
            } else if let data = data,
                      let response = response as? HTTPURLResponse,
                      response.statusCode == 200 {
                guard let token = self.parseTokenData(data)?.token else { return }
                completion(token)
            }
            
        }
        
        task.resume()
    }
    
    private func signInUrlRequest() -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = keywordsPath
        urlComponents.queryItems = [URLQueryItem(name: "client_id", value: "\(clientID)"), URLQueryItem(name: "client_secret", value: "\(clientSecret)"), URLQueryItem(name: "grant_type", value: "client_credentials")]
        
        guard let url = URL(string: "https://api.everypixel.com/oauth/token") else {return nil}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let postData = "client_id=4W6PvhrpejcQ2uV8aPNtnLOD&client_secret=mSVrJKYPtTa1oHlqw7D1cUg54AGqux5E4y5WLCryGbCAg67t&grant_type=client_credentials".data(using: .utf8)
        
        request.httpBody = postData
        
        return request
    }
    
    private func uploadRequestWith(boundary: String, accuracy: Float) -> URLRequest? {
        guard let token = keychainService.readToken() else { return nil }
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = keywordsPath
        urlComponents.queryItems = [URLQueryItem(name: "num_keywords", value: "5"), URLQueryItem(name: "threshold", value: "\(accuracy)")]
        
        guard let url = urlComponents.url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        return request
    }
    
    private func createDataBody(photo: UIImage?,  fileName: String, boundary: String) -> Data {
        let mimeType = "image/jpeg"
        let paramName = "data"
        let fileData = photo?.jpegData(compressionQuality: 1.0)
        let lineBreak = "\r\n"
        var body = Data()
        
        if let data = fileData {
            body.appendString("\(lineBreak)--\(boundary + lineBreak)")
            body.appendString("Content-Disposition: form-data; name=\"\(paramName)\"; filename=\"\(fileName)\"\(lineBreak)")
            body.appendString("Content-Type: \(mimeType + lineBreak + lineBreak)")
            body.append(data)
            body.appendString("\(lineBreak)--\(boundary)--\(lineBreak)")
        }
        
        return body
    }
    
    private func parseTokenData(_ data: Data) -> Token? {
        do {
            let decoder = JSONDecoder()
            let token = try decoder.decode(Token.self, from: data)
            return token
        } catch {
            debugPrint(error)
            print("JSONDecoder error: \(error.localizedDescription)\n")
            return nil
        }
    }
    
    private func parseTagsData(_ data: Data) -> [TagModel]? {
        do {
            let decoder = JSONDecoder()
            let tag = try decoder.decode(TagResultsModel.self, from: data)
            return tag.keywords
        } catch {
            debugPrint(error)
            print("JSONDecoder error: \(error.localizedDescription)\n")
            return nil
        }
    }
    
    private func parseApiErrorData(_ data: Data) -> String? {
        do {
            let decoder = JSONDecoder()
            let errorMessage = try decoder.decode(EveryPixelApiErrorModel.self, from: data)
            let message = errorMessage.message
            return message
        } catch {
            debugPrint(error)
            print("JSONDecoder error: \(error.localizedDescription)\n")
            return nil
        }
    }
    
    private func parseStatus(_ data: Data) -> EveryPixelStatus? {
        do {
            let decoder = JSONDecoder()
            let status = try decoder.decode(StatusModel.self, from: data)
            return EveryPixelStatus(rawValue: status.status)
        } catch {
            debugPrint(error)
            print("JSONDecoder error: \(error.localizedDescription)\n")
            return nil
        }
    }
    
    private func parseMessageErrorData(_ data: Data) -> String? {
        do {
            let decoder = JSONDecoder()
            let errorMessage = try decoder.decode(String.self, from: data)
            let message = errorMessage
            return message
        } catch {
            debugPrint(error)
            print("JSONDecoder error: \(error.localizedDescription)\n")
            return nil
        }
    }
    
    private func generateBoundary() -> String {
        return UUID().uuidString
    }
    
    private func isTokenExpired() -> Bool {
        let calendar = Calendar.current
        let now = Date()
        guard let dateSaved = self.lastDateTokenSaved else { return true }
        guard let oneHourAgo = calendar.date(bySettingHour: 1, minute: 0, second: 0, of: now) else { return true }
        
        let dateComparison = calendar.compare(dateSaved, to: oneHourAgo, toGranularity: .hour)
        
        switch dateComparison {
        case .orderedSame:
            return true
        case .orderedAscending:
            return true
        case .orderedDescending:
            return false
        }
    }
    
    private func signInSavingToken() {
        signInRequest(completion: { [weak self] token in
            if let token = token {
                self?.tokenSaved = ((self?.keychainService.saveToken(token: token)) != nil)
                self?.lastDateTokenSaved = Date()
            }
        })
    }
    
}


extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

