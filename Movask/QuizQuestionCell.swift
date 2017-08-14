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
        questionOptionsView.layoutDelegate = self
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector (repositionQuestion(_:)))
        dragButton.addGestureRecognizer(panGesture)
    }
    
    var question: QuestionTest? {
        didSet {
            guard let question = question else { return }
            
            questionTitleTextView.text = question.question
            questionOptionsView.question = question
            
            calculateCellHeightFor(question)
        }
    }
    
    override func prepareForReuse() {
        question = nil
        questionTitleTextView.text = ""
        questionOptionsView.answerVariants = [AnswerTest(title: "", isCorrect: false)]
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
    
    func calculateCellHeightFor(_ question: QuestionTest) {
        var minAnswersConteinerHeight: CGFloat = 33 + 16
        let textFieldInsets: CGFloat = 16.0
        for answer in question.answers {
            minAnswersConteinerHeight += answer.title.height(withConstrainedWidth: self.frame.width - 50 - 50 - 25 - 16 - 16 - 16, font: UIFont.systemFont(ofSize: 14))
            minAnswersConteinerHeight += textFieldInsets
        }
        
        let answersBlockHeight = minAnswersConteinerHeight
        questionOptionsViewHeight.constant = CGFloat(answersBlockHeight)
        
        let questionFieldHeight = question.question.height(withConstrainedWidth: self.frame.width - 50
            - 50 - 50 - 16 - 16 - 16 - 16, font: UIFont.systemFont(ofSize: 14)) + textFieldInsets

        questionTitleHeight.constant = questionFieldHeight
        questionTitleTextView.lineTopConstraint.constant = questionFieldHeight - questionTitleTextView.lineHeightConstraint.constant
        questionContainerHeight.constant = questionFieldHeight + 80.0
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
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
        }
        return true
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
    
    func didUpdateCollectionViewLayout(view: RadioButtonsView) {
        questionOptionsViewHeight.constant = view.answersCollectionViewView.contentSize.height + 16
        ownerCollectionView?.performBatchUpdates(nil)
    }
    
}










