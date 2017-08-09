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
    func didFinishEditingQuestion(cell: QuizQuestionCell)
}

class QuizQuestionCell: UICollectionViewCell {
    
    
    @IBOutlet weak var dragButton: UIButton!
    
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
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector (repositionQuestion(_:)))
        dragButton.addGestureRecognizer(panGesture)
    }
    
    var question: QuestionTest? {
        didSet {
            questionTitleTextView.text = question?.question
            guard let answers = question?.answers else { return }
            questionOptionsView.answerVariants = answers
        }
    }
    
    override func prepareForReuse() {
        question = nil
        questionTitleTextView.text = ""
        questionOptionsView.answerVariants = [AnswerTest(title: "")]
        questionOptionsView.answersCollectionViewView.reloadData()
        questionContainerHeight.constant = 110.0
        questionOptionsViewHeight.constant = 76.0
    }
    
    @IBAction func deleteQuestionButtonTapped(_ sender: UIButton) {
        print("delete question tapped")
        delegate?.didTapDeleteQuestionButton(cell: self, sender: sender)
    }
    
    @IBAction func dragQuestonButtonTapped(_ sender: UIButton) {
        print("drag question tapped")
    }
    
    func repositionQuestion(_ gesture: UILongPressGestureRecognizer) {
        guard let ownerCollectionView = ownerCollectionView else { return }
        
        switch(gesture.state) {
        case UIGestureRecognizerState.began:
            guard let selectedIndexPath = ownerCollectionView.indexPathForItem(at: gesture.location(in: ownerCollectionView)) else {
                break
            }
            ownerCollectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
            
        case UIGestureRecognizerState.changed:
            // use default x position and y position from touch
            ownerCollectionView.updateInteractiveMovementTargetPosition(CGPoint(x: ownerCollectionView.frame.width/2, y: gesture.location(in: ownerCollectionView).y))
            
        case UIGestureRecognizerState.ended:
            ownerCollectionView.endInteractiveMovement()
            
        default:
            ownerCollectionView.cancelInteractiveMovement()
        }
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
            ownerCollectionView?.performBatchUpdates(nil)

        default: break
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        switch textView {
        case questionTitleTextView:
            //update question title in model
            delegate?.didFinishEditingQuestion(cell: self)
        default: break
        }

    }
}

extension QuizQuestionCell: RadioButtonsViewDelegate {

    func answerVariantWasAdded(view: RadioButtonsView) {
    }
    
    func didUpdateCollectionViewLayout(view: RadioButtonsView) {
        questionOptionsViewHeight.constant = view.answersCollectionViewView.contentSize.height + 16
        ownerCollectionView?.performBatchUpdates(nil)
    }
    
    func radioWasSelectedOn(view: RadioButtonsView, with option: AnswerTest) {
    }
    
}










