//
//  QuestionTest.swift
//  Movask
//
//  Created by Alina Yehorova on 04.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import Foundation

class QuestionGetTest {
    
    var type: QuestionType
    
    var id = 1
    
    var question: String {
        switch type {
        case .checkmarks:
            return "What is the golden hour?"
        case .radiobuttons, .gaps:
            return "Who's American president?"
        }
    }
    
    var checkmarksAnswers = [AnswerTest(title: "The last hour before sunset",
                                       isCorrect: false),
                            AnswerTest(title: "The hour when shadows get really long ang light very red",
                                       isCorrect: true),
                            AnswerTest(title: "The hour after sunrize",
                                       isCorrect: true),
                            AnswerTest(title: "Is a period shortly after sunrise or before sunset during which daylight is redder and softer than when the Sun is higher in the sky",
                                       isCorrect: true)]
    
    var radioAnswers = [AnswerTest(title: "Obama",
                                   isCorrect: false),
                        AnswerTest(title: "Putin",
                                   isCorrect: false),
                        AnswerTest(title: "Tramp",
                                   isCorrect: true)]
    
    var answers: [AnswerTest] {
        switch type {
        case .checkmarks:
            return checkmarksAnswers
            
        case .radiobuttons, .gaps:
            return radioAnswers
        }
    } 
    
    // Gap
    
    let gapAnswer = "Sunset or sundown is the daily disappearance of the Sun below the horizon as a result of Earth's rotation. The Sun will set exactly due west at the equator on the spring and fall equinoxes, each of which occurs only once a year."
    
    let missingWordsIndexes = [2, 12, 18, 28, 42]
    
    var missingWords = [String]()
    var userWords = [String]()
    
    init(type: QuestionType) {
        self.type = type
    }
}
