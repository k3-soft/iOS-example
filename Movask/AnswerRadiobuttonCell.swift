//
//  AnswerRadiobuttonCell.swift
//  Movask
//
//  Created by Alina Yehorova on 07.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import UIKit

class AnswerRadiobuttonCell: AnswerSelectionCell {
    
    let radioOnGray = UIImage(named: "RadioOnGray")!
    let radioOnGreen = UIImage(named: "RadioOnGreen")!
    let radioOnOrange = UIImage(named: "RadioOnOrange")!
    let radioOff = UIImage(named: "RadioOffGray")!

    override var checked: Bool {
        didSet {
            if checked {
                checkboxButton.setImage(radioOnGray, for: .normal)
            } else {
                checkboxButton.setImage(radioOff, for: .normal)
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        checkboxButton.setImage(radioOff, for: .normal)
    }
    
    override func setResults() {
        super.setResults()
        
        guard let currentAnswer = answer else { return }
        
        if currentAnswer.isSelected, currentAnswer.isCorrect {
            setAsAnsweredAndCorrect()
            
        } else if currentAnswer.isSelected, !currentAnswer.isCorrect {
            setAsAnswerdAndWrong()
            
        } else if !currentAnswer.isSelected, currentAnswer.isCorrect {
            setAsNotAnsweredAndCorrect()
            
        } else {
            setAsEmpty()
        }
    }
    
    func setAsAnsweredAndCorrect() {
        checkboxButton.setImage(radioOnGreen, for: .normal)
    }
    
    func setAsAnswerdAndWrong() {
        checkboxButton.setImage(radioOnOrange, for: .normal)
    }
    
    func setAsNotAnsweredAndCorrect() {
        checkboxButton.setImage(radioOnGray, for: .normal)
    }
    
    func setAsEmpty() {
        checkboxButton.setImage(radioOff, for: .normal)
    }
}
