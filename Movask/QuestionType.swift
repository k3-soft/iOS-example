//
//  QuestionType.swift
//  Movask
//
//  Created by Alina Yehorova on 07.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import Foundation

enum QuestionType {
    
    case checkmarks
    case radiobuttons
    case gaps
    
    var instruction: String {
        
        switch self {
        case .checkmarks:
            return "Tick the correct answers to confirm"
        case .radiobuttons:
            return "Select only one correct answer to confirm"
        case .gaps:
            return "Click the gaps and start typing"
        }
    }
    
    var description: String {
        switch self {
        case .checkmarks:
            return "Multiple choice"
        case .radiobuttons:
            return "Single choice"
        case .gaps:
            return "Gaps"
        }
    }

}
