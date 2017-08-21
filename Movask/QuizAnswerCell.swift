//
//  QuizAnswerCell.swift
//  Movask
//
//  Created by mac on 08.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import UIKit

protocol RadioCellDelegate: class {
    func didTapDeleteButton(cell: QuizAnswerCell, sender: UIButton)
}

class QuizAnswerCell: UICollectionViewCell {
    
    @IBOutlet weak var answerCheckImageView: UIImageView!
    @IBOutlet weak var answerTextView: UnderLinedTextView!
    @IBOutlet weak var answerTextViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var deleteAnswerButton: UIButton!
    
    weak var ownerView: QuizAnswersView?
    weak var delegate: RadioCellDelegate?
    
    var checkedImage: UIImage?
    var unCheckedImage: UIImage?
    
    static let answerTextAttributes: [String: NSObject] = {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 0
        let font = UIFont.systemFont(ofSize: 14)
        
        let attributes = [NSParagraphStyleAttributeName : style, NSFontAttributeName : font]
        return attributes
    }()
    
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
            answerTextView.attributedText = NSAttributedString(string: answer.title, attributes: QuizAnswerCell.answerTextAttributes)
            
            selectedCell = answer.isSelected
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        answerTextView.delegate = self
    }
    
    override func prepareForReuse() {
        selectedCell = false
    }
    
    func calculateCellHeightFor(_ answer: AnswerTest) {
        let answerTextViewSize = answerTextView.sizeThatFits(CGSize(width: answerTextView.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        
        answerTextViewHeight.constant = CGFloat(answerTextViewSize.height)
        answerTextView.lineTopConstraint.constant = answerTextViewSize.height - answerTextView.lineHeightConstraint.constant
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let answer = answer else { return }
        calculateCellHeightFor(answer)
    }
    
    @IBAction func didTapDeleteButton(_ sender: UIButton) {
        delegate?.didTapDeleteButton(cell: self, sender: sender)
    }
    

}

extension QuizAnswerCell: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))

        switch textView {
        case answerTextView:
            // update textview height
            if let answer = answer {
                answer.title = textView.text
            }
            
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

}


