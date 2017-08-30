//
//  UserDefaultsManager.swift
//  Movask
//
//  Created by Alina Yehorova on 03.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import Foundation

enum UserDefaultKeys: String {
    case kNickname = "Nickname"
    case kUserID = "UserID"
    case kDeviceID = "DeviceID"
    case kDeviceToken = "DeviceToken"
}

class UserDefaultsManager {
    
    static let `default` = UserDefaultsManager()
    
    func getValue<T>(valueType: T.Type, forKey: UserDefaultKeys) -> T? {
        guard let value = UserDefaults.standard.value(forKey: forKey.rawValue) as? T else { return nil }
        return value
    }
    
    func writeValue<T>(_ value: T?, forKey: UserDefaultKeys) {
        UserDefaults.standard.set(value, forKey: forKey.rawValue)
    }
    
    func clearAllDefaults() {
        
        let appDomain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: appDomain)
        UserDefaults.standard.synchronize()
    }
}
