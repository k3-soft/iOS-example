//
//  ResultRating.swift
//  Movask
//
//  Created by Alina Yehorova on 14.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import Foundation

enum ResultRating {
    
    case bad
    case medium
    case good
    case best
    
    static func getResult(correctAnswers: Int, totalAmount: Int) -> ResultRating? {
        
        let percent = Float(correctAnswers) / Float(totalAmount) * 100.0
        
        switch percent {
        case 0..<50:
            return .bad
        case 50..<70:
            return .medium
        case 70..<100:
            return .good
        case 100:
            return .best
        default:
            return nil
        }
    }
    
    var localized: String {
        
        switch self {
        case .bad:
            return "Practice more"
        case .medium:
            return "Not bad"
        case .good:
            return "Well done"
        case .best:
            return "Awesome"
        }
    }
}
