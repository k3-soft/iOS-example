//
//  CreateQuizHeaderCell.swift
//  Movask
//
//  Created by mac on 07.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import UIKit

class CreateQuizHeaderCell: UICollectionViewCell {
    
    @IBOutlet weak var titleTextView: UnderLinedTextView!
    @IBOutlet weak var descriptionTextView: UnderLinedTextView!
    
    @IBOutlet weak var titleHeight: NSLayoutConstraint!
    @IBOutlet weak var descriptionHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        titleTextView.delegate = self
        descriptionTextView.delegate = self
    }
}

extension CreateQuizHeaderCell: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        
        //resize textview to fit text
        switch textView {
        case titleTextView:
            titleHeight.constant = newSize.height
            titleTextView.lineTopConstraint.constant = newSize.height - titleTextView.lineHeightConstraint.constant
        case descriptionTextView:
            descriptionHeight.constant = newSize.height
            descriptionTextView.lineTopConstraint.constant = newSize.height - descriptionTextView.lineHeightConstraint.constant

        default: break
        }
        textView.layoutIfNeeded()
    }
}
