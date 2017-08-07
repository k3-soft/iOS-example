//
//  QuestionCell.swift
//  Movask
//
//  Created by Alina Yehorova on 04.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import UIKit

class QuestionCell: UICollectionViewCell {
    
    // Labels
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    
    // Constraints
    @IBOutlet weak var heightQuestionLabel: NSLayoutConstraint!
    @IBOutlet weak var heightQuestionView: UIView!
    
    // Data
    var question: QuestionTest?
    
    static var heightQuestionViewWithoutLabel: CGFloat = 57.0
    
    static var cellHeight: CGFloat {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return 360.0
        } else {
            return 360.0
        }
    }

    func setWithQuestion(_ question: QuestionTest) {
        
        self.question = question
        
        // Get question height
        
        let height = question.question.textHeightWithFontSize(size: 15.0, viewWidth: bounds.width, offset: 14.0)
        
        heightQuestionLabel.constant = height
        questionLabel.text = question.question
    }

}
