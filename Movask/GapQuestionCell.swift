//
//  GapQuestionCellCollectionViewCell.swift
//  Movask
//
//  Created by Alina Yehorova on 10.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.


import UIKit

class GapQuestionCell: UICollectionViewCell, QuestionCellHandler {
    
    // Question
    @IBOutlet weak var questionView: UIView!
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var questionTextView: UITextView!
    
    // Buttons
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    
    // Constraints
    @IBOutlet weak var heightQuestionLabel: NSLayoutConstraint!
    @IBOutlet weak var heightQuestionView: NSLayoutConstraint!
    
    // Data
    var question: QuestionTest?
    var gapRanges = [NSRange]()
    
    // Input
    var userWords = [String]()
    var currentWord: String?
    var textFields = [UITextField]()
    
    // Handlers
    var confirmHandler: (()->())?
    var skipHandler: (()->())?
    
    // Sizes
    
    let heightQuestionViewWithoutLabel: CGFloat = 45.0
    
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
        
        // Set question gap and label height
        
        buildGap()
        getRangesOfGaps()
        
        let height = questionTextView.sizeThatFits(CGSize(width: bounds.width - 14.0 * 2, height: CGFloat.greatestFiniteMagnitude)).height
        
        heightQuestionLabel.constant = height
        heightQuestionView.constant = height + heightQuestionViewWithoutLabel
        layoutIfNeeded()
        
        addTextFields()
        
        // Set instruction
        
        instructionLabel.text = question.type.instruction
    }
    
    func buildGap() {
        
        var gapComponents = question!.gapAnswer.components(separatedBy: " ")
        
        for index in question!.missingWordsIndexes {
            guard index < gapComponents.count else { continue }
            
            let wordToHide: NSString = gapComponents[index] as NSString
            
            // Check if word has punctuation mark at the end (we have not replace it with "_")
            
            let lastCharacter: NSString = wordToHide.substring(from: wordToHide.length - 1) as NSString
            var punctuationAtTheEnd = false
            
            let punctuationsSet = CharacterSet(charactersIn: "?!,.:;")
            if lastCharacter.rangeOfCharacter(from: punctuationsSet).location != NSNotFound {
                punctuationAtTheEnd = true
            }
            
            // Compose hidden word with "_____" and add punctuation mark at the end (if needed)
            
            let numberOfLetters = wordToHide.length - (punctuationAtTheEnd ? 1 : 0)
            var hiddenWord = String(repeatElement("_", count: numberOfLetters))
            hiddenWord += punctuationAtTheEnd ? lastCharacter as String : ""
            
            // Save hidden word without punctuation mark
            
            if punctuationAtTheEnd {
                let wordWithoutPunctuation: NSString = wordToHide.substring(to: wordToHide.length - 1) as NSString
                question!.missingWords.append(wordWithoutPunctuation as String)
                
            } else {
                question!.missingWords.append(wordToHide as String)
            }
            
            // Replace word for label text
            
            gapComponents[index] = hiddenWord
        }
        
        questionTextView.text = gapComponents.joined(separator: " ")
    }
    
    func getRangesOfGaps() {
        
        let text = questionTextView.text! as NSString
        var textRange = NSMakeRange(0, text.length)
        
        for word in question!.missingWords {
            
            // Find next "_" in text
            
            let wordLength = word.characters.count
            let range: NSRange = text.range(of: "_", options: .caseInsensitive, range: textRange)
            
            if range.location != NSNotFound {
                // When it was found - get range of this word
                let wordRange = NSMakeRange(range.location, wordLength)
                gapRanges.append(wordRange)
                
                // Cut already looked text for next iteration
                textRange = NSMakeRange(wordRange.location + wordLength, text.length - (wordRange.location + wordLength))
            }
        }
    }
    
    func addTextFields() {
        
        for range in gapRanges {
            
            // Get frame for text field
            var frame = boundingRectForCharacterRange(range)
            frame.origin.y += 5
            
            // Create text field
            let textField = UITextField(frame: frame)
            textField.font = UIFont(name: "Solomon-Sans-SemiBold", size: 17.0)
            textField.textAlignment = .center
            textField.textColor = UIColor.white
            textField.clearsOnBeginEditing = true
            textField.autocapitalizationType = .none
            textField.tintColor = UIColor.white
            textField.delegate = self
            
            questionTextView.addSubview(textField)
            textFields.append(textField)
        }
    }
    
    func boundingRectForCharacterRange(_ range: NSRange) -> CGRect {
        
        let glyphRange = questionTextView.layoutManager.glyphRange(forCharacterRange: range, actualCharacterRange: nil)
        let glyphContainer = questionTextView.layoutManager.textContainer(forGlyphAt: glyphRange.location, effectiveRange: nil)
        let glyphRect = questionTextView.layoutManager.boundingRect(forGlyphRange: glyphRange, in: glyphContainer!)
        
        return glyphRect
    }
    
    // MARK: - Actions
    
    @IBAction func confirmDidTap(_ sender: UIButton) {
        confirmHandler?()
    }
    
    @IBAction func skipDidTap(_ sender: UIButton) {
        skipHandler?()
    }
}

extension GapQuestionCell: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if let vc = viewController() as? QuizPhoneVC {
            return vc.isQuizStarted
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        viewController()?.hideKeyboardWhenTappedAround()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // Find text field in saved and hidden word for it
        guard let index = textFields.index(of: textField),
            index < question!.missingWords.count,
            textField.text != nil else { return false }
        
        let word = question!.missingWords[index]
        
        // Allow type only letters
        let set = NSCharacterSet.letters.inverted
        if string.rangeOfCharacter(from: set) != nil || string == "\n" { return false }
        
        // Max allowed number of symbols in text field is count of letters in hidden word
        
        let newString: NSString = (textField.text! as NSString).replacingCharacters(in: range, with: string) as NSString
        
        if newString.length > word.characters.count {
            return false
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
