//
//  QuestionTest.swift
//  Movask
//
//  Created by Alina Yehorova on 04.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import Foundation

class QuestionTest {
    
    let id = 1
    let question = "What is the golden hour?"
    let type: QuestionType = .checkmarks
    
    let answers = [AnswerTest(title: "The last hour before sunset"),
                   AnswerTest(title: "The hour when shadows get really long ang light very red"),
                   AnswerTest(title: "The hour after sunrize"),
                   AnswerTest(title: "Is a period shortly after sunrise or before sunset during which daylight is redder and softer than when the Sun is higher in the sky")]
}
