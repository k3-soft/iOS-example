//
//  QuizQuestionCell.swift
//  Movask
//
//  Created by mac on 07.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import UIKit

protocol QuizQuestionCellDelegate: class {
    func didTapDeleteQuestionButton(cell: QuizQuestionCell, sender: UIButton)
}

class QuizQuestionCell: UICollectionViewCell {
    
    @IBOutlet weak var questionContainer: UIView!
    @IBOutlet weak var questionIndexLabel: UILabel!
    @IBOutlet weak var qustionTypeDescriptionLabel: UILabel!
    @IBOutlet weak var questionTitleTextView: UnderLinedTextView!
    @IBOutlet weak var questionOptionsView: RadioButtonsView!

    @IBOutlet weak var questionContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var questionOptionsViewHeight: NSLayoutConstraint!
    @IBOutlet weak var questionTitleHeight: NSLayoutConstraint!

    weak var delegate: QuizQuestionCellDelegate?
    weak var ownerCollectionView: UICollectionView?
    
    override func awakeFromNib() {
        questionTitleTextView.delegate = self
        questionOptionsView.delegate = self
    }
    
    @IBAction func deleteQuestionButtonTapped(_ sender: UIButton) {
        print("delete question tapped")
        delegate?.didTapDeleteQuestionButton(cell: self, sender: sender)
    }
    @IBAction func dragQuestonButtonTapped(_ sender: UIButton) {
        print("drag question tapped")
    }

}

extension QuizQuestionCell: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        
        switch textView {
        case questionTitleTextView:
            // update textview height
            questionTitleHeight.constant = newSize.height
            questionTitleTextView.lineTopConstraint.constant = newSize.height - questionTitleTextView.lineHeightConstraint.constant
            
            //update container height
            questionContainerHeight.constant = newSize.height + 80.0
            
            //update collectionview cell height
            ownerCollectionView?.collectionViewLayout.invalidateLayout()
        default: break
        }
        textView.layoutIfNeeded()
    }
}

extension QuizQuestionCell: RadioButtonsViewDelegate {

    func answerVariantWasAdded(view: RadioButtonsView) {
        questionOptionsViewHeight.constant = CGFloat(view.answerVariants.count + 1) * view.cellHeight + 16
        ownerCollectionView?.collectionViewLayout.invalidateLayout()
    }
    
}










