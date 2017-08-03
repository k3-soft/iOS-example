//
//  Token.swift
//  Movask
//
//  Created by Alina Yehorova on 03.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import CloudKit

class Token {
    
    var name: String!
    
    init(record: CKRecord) {
        self.name = record["Name"] as? String
    }
}
