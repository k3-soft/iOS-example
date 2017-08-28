//
//  Enum+Iteration.swift
//  Movask
//
//  Created by mac on 28.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import Foundation

func iterateEnum<T: Hashable>(_: T.Type) -> AnyIterator<T> {
    var i = 0
    return AnyIterator {
        let next = withUnsafeBytes(of: &i) { $0.load(as: T.self) }
        if next.hashValue != i { return nil }
        i += 1
        return next
    }
}
