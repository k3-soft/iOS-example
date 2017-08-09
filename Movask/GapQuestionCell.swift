//
//  GapQuestionCellCollectionViewCell.swift
//  Movask
//
//  Created by Alina Yehorova on 10.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import UIKit

class GapQuestionCell: UICollectionViewCell, QuestionCellHandler {

    // Question
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var questionTextView: UITextView!
    
    // Buttons
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    
    // Constraints
    @IBOutlet weak var heightTextView: NSLayoutConstraint!
    @IBOutlet weak var heightQuestionView: NSLayoutConstraint!
    
    // Data
    var question: QuestionTest?
    
    // Handlers
    var confirmHandler: (()->())?
    var skipHandler: (()->())?
    
    // Sizes
    
    let heightQuestionViewWithoutLabel: CGFloat = 35.0
    
    static var cellHeight: CGFloat {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return 435.0
        } else {
            return 435.0
        }
    }
    
    // MARK: - Set cell
    
    func setWithQuestion(_ question: QuestionTest) {
        
        self.question = question
        
        // Set question gap and text view height
        
        buildGap()
        
        let textViewHeight = questionTextView.contentSize.height
        heightTextView.constant = textViewHeight
        heightQuestionView.constant = textViewHeight + heightQuestionViewWithoutLabel
        
        // Set labels
        
        instructionLabel.text = question.type.instruction
    }
    
    func buildGap() {
        
        var gapComponents = question!.gapAnswer.components(separatedBy: " ")
        
        for index in question!.missingWordsIndexes {
            guard index < gapComponents.count else { continue }
            
            let wordToHide = gapComponents[index]
            
            question!.missingWords.append(wordToHide)
            
            let numberOfLetters = wordToHide.characters.count
            gapComponents[index] = String(repeatElement("_", count: numberOfLetters))
        }
        
        questionTextView.text = gapComponents.joined(separator: " ")
    }
    
    // MARK: - Actions
    
    @IBAction func confirmDidTap(_ sender: UIButton) {
        confirmHandler?()
    }
    
    @IBAction func skipDidTap(_ sender: UIButton) {
        skipHandler?()
    }

}
