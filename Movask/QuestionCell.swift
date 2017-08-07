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
    
    // Buttons
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    
    // Constraints
    @IBOutlet weak var heightQuestionLabel: NSLayoutConstraint!
    @IBOutlet weak var heightQuestionView: NSLayoutConstraint!
    
    // Data
    var question: QuestionTest?
    
    // Handlers
    var confirmHandler: (()->())?
    var skipHandler: (()->())?
    
    let heightQuestionViewWithoutLabel: CGFloat = 43.0
    
    static var cellHeight: CGFloat {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return 435.0
        } else {
            return 435.0
        }
    }

    func setWithQuestion(_ question: QuestionTest) {
        
        self.question = question
        
        // Get question height
        
        let height = question.question.textHeightWithFontSize(size: 15.0, viewWidth: bounds.width, offset: 0.0)
        
        heightQuestionLabel.constant = height
        heightQuestionView.constant = height + heightQuestionViewWithoutLabel
        questionLabel.text = question.question
    }
    
    // MARK: - Actions
    
    @IBAction func confirmDidTap(_ sender: UIButton) {
        confirmHandler?()
    }
    
    @IBAction func skipDidTap(_ sender: UIButton) {
        skipHandler?()
    }
}
