//
//  AuthorizationManager.swift
//  Movask
//
//  Created by Alina Yehorova on 03.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import UIKit

enum ICloudError: Error {
    case databaseError
    case tokenNotExist
}

class AuthorizationManager {
    
    static var token: String? {
        return UserDefaultsManager.default.getValue(valueType: String.self, forKey: .kDeviceID)
    }
    
    class func setToken() {
        
        sharedInstance.getTokenFromICloud { (token, error) in
            if error != nil {
                sharedInstance.getTokenFromDevice()
            } else {
                guard let tokenName = token?.name else {
                    print("Token hasn't name")
                    sharedInstance.getTokenFromDevice()
                    return
                }
                print("Token received from ICloud: \(tokenName)")
                UserDefaultsManager.default.writeValue(tokenName, forKey: .kDeviceID)
            }
        }
    }
    
    @discardableResult class func updateProfile(with data: Any) -> Profile? {
        
        guard let json = data as? [String: Any],
            let profile = Profile(JSON: json) else { return nil }
            
        UserDefaultsManager.default.writeValue(profile.username, forKey: .kNickname)
        
        return profile
    }
    
    // MARK: - Private
    
    static private var sharedInstance = AuthorizationManager()
    
    private var deviceID: String? {
        return UIDevice.current.identifierForVendor?.uuidString
    }
    
    private func getTokenFromICloud(completion: @escaping (_ results: Token?, _ error: ICloudError?) -> ()) {
        
        ICloudModel.sharedInstance.getToken { (tokens, error) in
            
            guard error == nil else {
                print("Error getting token from ICloud: \(error!.localizedDescription)")
                completion(nil, ICloudError.databaseError)
                return
            }
            guard !tokens!.isEmpty else {
                completion(nil, ICloudError.tokenNotExist)
                return
            }
            let token = tokens!.first!
            completion(token, nil)
        }
    }
    
    private func getTokenFromDevice() {
        
        guard let newToken = deviceID else {
            return
        }
        UserDefaultsManager.default.writeValue(newToken, forKey: .kDeviceID)
        writeNewTokenToICloud(token: newToken)
    }
    
    private func writeNewTokenToICloud(token: String) {
        print("No tokens in ICloud database. Write new: \(token)")
        ICloudModel.sharedInstance.writeToken(token: token)
    }
}
