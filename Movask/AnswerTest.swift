//
//  AnswerTest.swift
//  Movask
//
//  Created by Alina Yehorova on 07.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import Foundation

class AnswerTest {
    
    var title: String
    var isCorrect: Bool
    
    init(title: String, isCorrect: Bool) {
        self.title = title
        self.isCorrect = isCorrect
    }
    
    var isSelected = false
    
    var isAccepted: Bool {
        if isCorrect, isSelected { return true }
        else if !isCorrect, !isSelected { return true }
        else { return false }
    }
}

