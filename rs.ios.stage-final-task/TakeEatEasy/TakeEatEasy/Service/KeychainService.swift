//
//  KeychainService.swift
//  TakeEatEasy
//
//  Created by Nadezhda Zenkova on 15.11.2021.
//

import Foundation
//
// MARK: - UserCredentials
//
struct EveryPixelUserCredentials: Codable {
    var clientId: String
    var clientSecret: String
    var token: String?
}
//
// MARK: - Keychain Service
//

class KeychainService {
    
    private let server = "https://api.everypixel.com"
    
    public func saveToken(account: String? = "TIE", token: String) -> Bool {
        let account = account
        let token = token.data(using: String.Encoding.utf8)!
        
        if readToken() != nil {
            var attributesToUpdate = [String : AnyObject]()
            attributesToUpdate[kSecValueData as String] = token as AnyObject
            
            
            let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                        kSecAttrAccount as String: account,
                                        kSecAttrServer as String: server,
                                        kSecValueData as String: token]
            let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
            return status == noErr
        }
        
        let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                    kSecAttrAccount as String: account,
                                    kSecAttrServer as String: server,
                                    kSecValueData as String: token]
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == noErr
    }
    
    
    public func readToken() -> String? {
        let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                    kSecAttrServer as String: server,
                                    kSecMatchLimit as String: kSecMatchLimitOne,
                                    kSecReturnAttributes as String: true,
                                    kSecReturnData as String: true]
        
        
        var queryResult: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer(&queryResult))
        
        if status != noErr {
            return nil
        }
        
        guard let item = queryResult as? [String : AnyObject],
              let tokenData = item[kSecValueData as String] as? Data,
              let token = String(data: tokenData, encoding: .utf8) else {
            //let account = item[kSecAttrAccount as String] as? String else {
            return nil
        }
        return token
    }
    
    func deleteToken() -> Bool {
        let item: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                   kSecAttrServer as String: server]
        //kSecAttrAccount as String: account]
        let status = SecItemDelete(item as CFDictionary)
        return status == noErr
    }
    
}
