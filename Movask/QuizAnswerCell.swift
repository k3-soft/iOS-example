//
//  QuizAnswerCell.swift
//  Movask
//
//  Created by mac on 08.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import UIKit

protocol RadioCellDelegate: class {
    func didFinishEditingAnswer(cell: QuizAnswerCell)
}

class QuizAnswerCell: UICollectionViewCell {
    
    @IBOutlet weak var answerCheckImageView: UIImageView!
    @IBOutlet weak var answerTextView: UnderLinedTextView!
    @IBOutlet weak var answerTextViewHeight: NSLayoutConstraint!
    
    weak var ownerView: QuizAnswersView?
    weak var delegate: RadioCellDelegate?
    
    var checkedImage: UIImage?
    var unCheckedImage: UIImage?
    
    var selectionType: QuestionType? {
        willSet {
            guard let selectionType = newValue else { return }
            switch selectionType {
            case .checkmarks:
                checkedImage = UIImage(named: "CheckGray")
                unCheckedImage = UIImage(named: "CheckEmptyGray")
            case .radiobuttons:
                checkedImage = UIImage(named: "RadioOnGray")
                unCheckedImage = UIImage(named: "RadioOffGray")
            default: break
            }
        }
    }
    
    var selectedCell = false {
        didSet {
            if selectedCell {
                answerTextView.textColor = UIColor(colorWithHexValue: 0x417505)
                answerCheckImageView.image = checkedImage
            } else {
                answerTextView.textColor = UIColor(colorWithHexValue: 0x808080)
                answerCheckImageView.image = unCheckedImage
            }
        }
    }
    
    var answer: AnswerTest? {
        didSet {
            guard let answer = answer else { return }
            answerTextView.text = answer.title
            selectedCell = answer.isSelected
            calculateCellHeightFor(answer)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        answerTextView.delegate = self
    }
    
    override func prepareForReuse() {
        answerTextViewHeight.constant = 33
        selectedCell = false
    }
    
    func calculateCellHeightFor(_ answer: AnswerTest) {
        let answerTextViewWidth: CGFloat = self.frame.width - 25 - 16 - 8
        
        let answerTextViewSize = answerTextView.sizeThatFits(CGSize(width: answerTextViewWidth, height: CGFloat.greatestFiniteMagnitude))
        
        answerTextViewHeight.constant = CGFloat(answerTextViewSize.height)
        answerTextView.lineTopConstraint.constant = answerTextViewSize.height - answerTextView.lineHeightConstraint.constant
    }

}

extension QuizAnswerCell: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        print(newSize.height)
        switch textView {
        case answerTextView:
            // update textview height
            answerTextViewHeight.constant = newSize.height
            answerTextView.lineTopConstraint.constant = newSize.height - answerTextView.lineHeightConstraint.constant

            ownerView?.updateCollectionViewLayout()
        default: break
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        switch textView {
        case answerTextView:
            //update question title in model
            delegate?.didFinishEditingAnswer(cell: self)
        default: break
        }
        
    }
}


