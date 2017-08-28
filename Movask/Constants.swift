//
//  Constants.swift
//  Movask
//
//  Created by Alina Yehorova on 03.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import UIKit

let BaseAPIUrl = "http://api.aftervideo.k-3soft.com/api/"
let BaseAPIUploads = "http://api.aftervideo.k-3soft.com/api/"

let MainFontSemibold = "Solomon-Sans-SemiBold"
let MainFontBold = "Solomon-Sans-Bold"

// MARK: - Colors

struct BrandColor {
    
    static let lightGray = UIColor(colorWithHexValue: 0xEEEEEE)
    static let gray = UIColor(colorWithHexValue: 0x9C9C9C)
    static let darkGrey = UIColor(colorWithHexValue: 0x4A4A4A)
    static let green = UIColor(colorWithHexValue: 0x2CB463)
    static let darkGreen = UIColor(colorWithHexValue: 0x1F6B3D)
    static let orange = UIColor(colorWithHexValue: 0xFAAA00)
}


let allQuestionTypes: [QuestionType] = {
    var questionTypes: [QuestionType] = []
    for questionType in iterateEnum(QuestionType.self) {
        questionTypes.append(questionType)
    }
    return questionTypes
}()
