//
//  RadioCell.swift
//  Movask
//
//  Created by mac on 08.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import UIKit

class RadioCell: UICollectionViewCell {
    
    @IBOutlet weak var radioImage: UIImageView!
    @IBOutlet weak var radioTextView: UnderLinedTextView!
    @IBOutlet weak var radioTextViewHeight: NSLayoutConstraint!
    
    weak var ownerView: RadioButtonsView?
    
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        radioTextView.delegate = self
    }
    
    override func prepareForReuse() {
        radioTextViewHeight.constant = 30
    }
}

extension RadioCell: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        
        switch textView {
        case radioTextView:
            // update textview height
            radioTextViewHeight.constant = newSize.height
            radioTextView.lineTopConstraint.constant = newSize.height - radioTextView.lineHeightConstraint.constant

            ownerView?.updateCollectionViewLayout()
        default: break
        }
    }
    
//    func textViewDidEndEditing(_ textView: UITextView) {
//        switch textView {
//        case questionTitleTextView:
//            //update question title in model
//            delegate?.didFinishEditingQuestion(cell: self)
//        default: break
//        }
//        
//    }
}


