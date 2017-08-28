//
//  ProfilePostModel.swift
//  Movask
//
//  Created by Alina Yehorova on 28.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import Foundation
import ObjectMapper

class Profile: Mappable {
    
    var username: String?
    var deviceID: String?
    
    init() {}
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        username <- map["username"]
        deviceID <- map["deviceId"]
    }
}
