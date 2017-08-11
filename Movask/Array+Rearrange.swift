//
//  Array+Reposition.swift
//  Movask
//
//  Created by mac on 10.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import Foundation

extension Array {
    mutating func rearrange(from: Int, to: Int) {
        precondition(from != to && indices.contains(from) && indices.contains(to), "invalid indexes")
        insert(remove(at: from), at: to)
    }
}
