//
//  ResultGapQuestionCell.swift
//  Movask
//
//  Created by Alina Yehorova on 14.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import UIKit

class ResultGapQuestionCell: UICollectionViewCell {
    
    // Question
    @IBOutlet weak var questionView: UIView!
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var questionTextView: UITextView!
    @IBOutlet weak var resultTextView: UITextView!
    
    // Constraints
    @IBOutlet weak var heightQuestionLabel: NSLayoutConstraint!
    @IBOutlet weak var heightQuestionView: NSLayoutConstraint!
    
    // Data
    var question: QuestionGetTest?
    var gapRanges = [NSRange]()
    
    // Managers
    let gapManager = GapManager()
    
    // Input
    var textFields = [UITextField]()
    
    // Sizes
    
    let heightQuestionViewWithoutLabel: CGFloat = 45.0
    
    static var cellHeight: CGFloat {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return 360.0
        } else {
            return 405.0
        }
    }
    
    var cellSideInsets: CGFloat {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return 44.0
        } else {
            return 260.0
        }
    }
    
    var textViewInsets: CGFloat {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return 14.0 * 2
        } else {
            return 20.0 * 2
        }
    }
    
    // Font
    
    var textFieldsFont: UIFont {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return UIFont(name: MainFontSemibold, size: 17.0)!
        } else {
            return UIFont(name: MainFontBold, size: 17.0)!
        }
    }
    
    override func prepareForReuse() {
        
        for textField in textFields {
            textField.removeFromSuperview()
        }
        
        textFields.removeAll()
        gapRanges.removeAll()
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.autoresizingMask.insert(.flexibleHeight)
        contentView.autoresizingMask.insert(.flexibleWidth)
        contentView.translatesAutoresizingMaskIntoConstraints = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !textFields.isEmpty {
            layoutGaps(animated: false)
        }
    }
    
    // MARK: - Reload
    
    func reload(viewWidth: CGFloat) {
        
        setViewHeight(cellWidth: viewWidth - cellSideInsets)
        
        for textField in textFields {
            textField.alpha = 0.0
        }
    }
    
    func layoutGaps(animated: Bool = true) {
        
        (0 ..< gapRanges.count).forEach { (index) in
            let frame = boundingRectForCharacterRange(gapRanges[index])
            textFields[index].frame = frame
            
            if animated {
                UIView.animate(withDuration: 0.2, animations: {
                    self.textFields[index].alpha = 1.0
                })
            }
        }
    }
    
    // MARK: - Set cell
    
    func setWithQuestion(_ question: QuestionGetTest) {
        
        self.question = question
        
        // Set question gap and label height
        
        buildGap()
        getRangesOfGaps()
        setViewHeight(cellWidth: bounds.width)
        addTextFields()
        setResults()
        
        // Set instruction
        
        instructionLabel.text = question.type.instruction
    }
    
    func setViewHeight(cellWidth: CGFloat) {
        
        let height = questionTextView.sizeThatFits(CGSize(width: cellWidth - textViewInsets, height: CGFloat.greatestFiniteMagnitude)).height
        
        heightQuestionLabel.constant = height
        heightQuestionView.constant = height + heightQuestionViewWithoutLabel
        layoutIfNeeded()
    }
    
    func setResults() {
        
        guard let missingWords = question?.missingWords,
            let userWords = question?.userWords,
            userWords.count == textFields.count,
            userWords.count == missingWords.count else { return }
        
        resultTextView.text = question?.gapAnswer
        
        (0 ..< textFields.count).forEach { (index) in
            textFields[index].text = userWords[index]
            
            if userWords[index] != missingWords[index] {
                textFields[index].textColor = BrandColor.orange
            } else {
                textFields[index].textColor = UIColor.white
            }
        }
    }
    
    func buildGap() {
        
        question?.missingWords.removeAll()
        
        let result = gapManager.buildGap(text: question!.gapAnswer, missingWordsIndexes: question!.missingWordsIndexes)
        
        question!.missingWords = result.missingWords
        questionTextView.text = result.resultText
    }
    
    func getRangesOfGaps() {
        gapRanges = gapManager.getRangesOfGaps(in: questionTextView, missingWords: question!.missingWords)
    }
    
    func addTextFields() {
        
        for range in gapRanges {
            
            // Get frame for text field
            let frame = boundingRectForCharacterRange(range)
            
            // Create text field
            let textField = UITextField(frame: frame)
            textField.font = textFieldsFont
            textField.textAlignment = .center
            textField.clearsOnBeginEditing = true
            textField.autocapitalizationType = .none
            textField.tintColor = UIColor.white
            textField.isEnabled = false
            
            questionTextView.addSubview(textField)
            textFields.append(textField)
        }
    }
    
    func boundingRectForCharacterRange(_ range: NSRange) -> CGRect {
        
        var frame = gapManager.boundingRectForCharacterRange(in: questionTextView, range: range)
        
        // Make frame little wider for long words
        frame = CGRect(x: frame.origin.x - 5, y: frame.origin.y + 5, width: frame.size.width + 10, height: frame.size.height)
        
        return frame
    }
}
