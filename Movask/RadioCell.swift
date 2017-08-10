//
//  RadioCell.swift
//  Movask
//
//  Created by mac on 08.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import UIKit

protocol RadioCellDelegate: class {
    func didFinishEditingAnswer(cell: RadioCell)
}

class RadioCell: UICollectionViewCell {
    
    @IBOutlet weak var radioImage: UIImageView!
    @IBOutlet weak var radioTextView: UnderLinedTextView!
    @IBOutlet weak var radioTextViewHeight: NSLayoutConstraint!
    
    weak var ownerView: RadioButtonsView?
    weak var delegate: RadioCellDelegate?
    
    var selectedCell = false {
        didSet {
            if selectedCell {
                radioTextView.textColor = UIColor(colorWithHexValue: 0x417505)
                radioImage.image = UIImage(named: "RadioOnGray")
            } else {
                radioTextView.textColor = UIColor(colorWithHexValue: 0x808080)
                radioImage.image = UIImage(named: "RadioOffGray")
            }
        }
    }
    
    var answer: AnswerTest? {
        didSet {
            guard let answer = answer else { return }
            radioTextView.text = answer.title
            selectedCell = answer.isSelected
            calculateCellHeightFor(answer)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        radioTextView.delegate = self
    }
    
    override func prepareForReuse() {
        radioTextViewHeight.constant = 33
        selectedCell = false
    }
    
    func calculateCellHeightFor(_ answer: AnswerTest) {
        let textFieldInsets: CGFloat = 16.0
        
        let answerFieldHeight = answer.title.height(withConstrainedWidth: self.frame.width - 25 + 5, font: UIFont.systemFont(ofSize: 14)) + textFieldInsets

        radioTextViewHeight.constant = CGFloat(answerFieldHeight)
        radioTextView.lineTopConstraint.constant = answerFieldHeight - radioTextView.lineHeightConstraint.constant
    }

}

extension RadioCell: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        print(newSize.height)
        switch textView {
        case radioTextView:
            // update textview height
            radioTextViewHeight.constant = newSize.height
            radioTextView.lineTopConstraint.constant = newSize.height - radioTextView.lineHeightConstraint.constant

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
        case radioTextView:
            //update question title in model
            delegate?.didFinishEditingAnswer(cell: self)
        default: break
        }
        
    }
}


