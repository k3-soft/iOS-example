//
//  AnswerSelectionCell.swift
//  Movask
//
//  Created by Alina Yehorova on 07.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import UIKit

protocol AnswerSelectionCellDelegate: class {
    func answerSelected(cell: AnswerSelectionCell)
}

class AnswerSelectionCell: UITableViewCell {
    
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var heightAnswerLabel: NSLayoutConstraint!
    
    @IBOutlet weak var checkboxButton: UIButton! {
        didSet {
            checkboxButton.touchAreaEdgeInsets = .init(top: -10, left: -10, bottom: -10, right: -10)
        }
    }
    
    weak var delegate: AnswerSelectionCellDelegate?
    
    var isActive = true {
        didSet {
            checkboxButton.isEnabled = isActive
        }
    }
    
    var answer: AnswerTest?
    
    // Sizes
    
    static var cellHeight: CGFloat {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return 25.0
        } else {
            return 25.0
        }
    }
    
    static let textOffset: CGFloat = 73.0
    
    // MARK: - Status
    
    var checked = false {
        didSet {
            if checked {
                checkboxButton.setImage(grayBox, for: .normal)
            } else {
                checkboxButton.setImage(emptyBox, for: .normal)
            }
        }
    }
    
    var type: QuestionType? {
        didSet {
            checkboxButton.setImage(emptyBox, for: .normal)
        }
    }
    
    // MARK: - States images
    
    var emptyBox: UIImage? {
        switch type! {
        case .checkmarks:
            return UIImage(named: "CheckEmptyGray")!
        case .radiobuttons:
            return UIImage(named: "RadioOffGray")!
        default:
            return nil
        }
    }
    
    var grayBox: UIImage? {
        switch type! {
        case .checkmarks:
            return UIImage(named: "CheckGray")!
        case .radiobuttons:
            return UIImage(named: "RadioOnGray")!
        default:
            return nil
        }
    }
    
    var greenBox: UIImage? {
        switch type! {
        case .checkmarks:
            return UIImage(named: "CheckGreen")!
        case .radiobuttons:
            return UIImage(named: "RadioOnGreen")!
        default:
            return nil
        }
    }
    
    var orangeBox: UIImage? {
        switch type! {
        case .checkmarks:
            return UIImage(named: "CheckErrorOrange")!
        case .radiobuttons:
            return UIImage(named: "RadioOnOrange")!
        default:
            return nil
        }
    }
    
    // MARK: - Set cell
    
    override func prepareForReuse() {
        super.prepareForReuse()
        checked = false
    }
    
    func setWithAnswer(_ answer: AnswerTest, showResults: Bool) {
        
        self.answer = answer
        
        // Get answer height
        
        let height = AnswerSelectionCell.getCellHeightFor(viewWidth: bounds.width, answer: answer)
        
        heightAnswerLabel.constant = height
        answerLabel.text = answer.title
        
        // Set results
        
        if showResults {
            setResults()
        }
    }
    
    // MARK: - Actions
    
    @IBAction func ckeckboxDidTap(_ sender: UIButton) {
        
        guard let vc = viewController() as? QuizVC, vc.isQuizStarted else { return }
        
        checked = !checked
        answer?.isSelected = checked
        
        delegate?.answerSelected(cell: self)
    }
    
    // MARK: - Class functions
    
    static func getTextHeight(answer: AnswerTest, cellWidth: CGFloat) -> CGFloat {
        
        return answer.title.textHeightWithFont(size: 15.0, name: MainFontSemibold, viewWidth: cellWidth - textOffset, offset: 0.0)
    }
    
    static func getCellHeightFor(viewWidth: CGFloat, answer: AnswerTest) -> CGFloat {
        
        let textHeight = getTextHeight(answer: answer, cellWidth: viewWidth)
        
        return cellHeight + textHeight
    }
    
    // MARK: - Results
    
    func setResults() {
        
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
        checkboxButton.setImage(greenBox, for: .normal)
    }
    
    func setAsAnswerdAndWrong() {
        checkboxButton.setImage(orangeBox, for: .normal)
    }
    
    func setAsNotAnsweredAndCorrect() {
        checkboxButton.setImage(grayBox, for: .normal)
    }
    
    func setAsEmpty() {
        checkboxButton.setImage(emptyBox, for: .normal)
    }
}
