//
//  ProfileRegistrationForm.swift
//  Movask
//
//  Created by Alina Yehorova on 28.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import Foundation
import ObjectMapper

class ProfileRegistrationForm: Mappable {
    
    var profileForm: Profile?
    
    init(profileForm: Profile) {
        self.profileForm = profileForm
    }
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        profileForm <- map["registrationForm"]
    }
}

class ProfileEditForm: Mappable {
    
    var profileForm: Profile?
    
    init(profileForm: Profile) {
        self.profileForm = profileForm
    }
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        profileForm <- map["profileForm"]
    }
}

