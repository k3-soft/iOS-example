//
//  QuizQuestionAnswersCell.swift
//  Movask
//
//  Created by mac on 07.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import UIKit

protocol QuizQuestionCellDelegate: class {
    func didTapDeleteQuestionButton(cell: QuizQuestionAnswersCell, sender: UIButton)
    func didFinishEditingQuestion(cell: QuizQuestionAnswersCell)
}

class QuizQuestionAnswersCell: UICollectionViewCell {
    
    @IBOutlet weak var dragButton: UIButton!
    
    @IBOutlet weak var questionContainer: UIView!
    @IBOutlet weak var questionIndexLabel: UILabel!
    
    @IBOutlet weak var questionTypeLabel: UILabel!
    @IBOutlet weak var qustionTypeDescriptionLabel: UILabel!
    
    @IBOutlet weak var questionTitleTextView: UnderLinedTextView!
    @IBOutlet weak var questionOptionsView: QuizAnswersView?

    @IBOutlet weak var questionContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var questionOptionsViewHeight: NSLayoutConstraint!
    @IBOutlet weak var questionTitleHeight: NSLayoutConstraint!

    weak var delegate: QuizQuestionCellDelegate?
    weak var ownerCollectionView: UICollectionView?
    
    override func awakeFromNib() {
        questionTitleTextView.delegate = self
        questionOptionsView?.layoutDelegate = self
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector (repositionQuestion(_:)))
        dragButton.addGestureRecognizer(panGesture)
    }
    
    var gapButtons: [GapButton] = []
    
    var question: QuestionPostTest? {
        didSet {
            guard let question = question else { return }
            
            questionIndexLabel.text = "\(question.id + 1)."
            questionTypeLabel.text = question.type.description
            qustionTypeDescriptionLabel.text = question.type.instruction
            
            switch question.type {
            case .gaps:
                questionOptionsView = nil
                
                let style = NSMutableParagraphStyle()
                style.lineSpacing = 30
                let font = UIFont.boldSystemFont(ofSize: 14)
                
                let attributes = [NSParagraphStyleAttributeName : style, NSFontAttributeName : font, NSForegroundColorAttributeName : UIColor.white]
                questionTitleTextView.attributedText = NSAttributedString(string: question.gapAnswer, attributes: attributes)
                
                addGapButtons(for: question)
                
            default:
                questionTitleTextView.text = question.question
            }
            questionOptionsView?.question = question
            calculateCellHeightFor(question)
        }
    }
    
    override func prepareForReuse() {
//        questionTitleTextView.text = ""
//        questionOptionsViewHeight.constant = 0
//        questionContainerHeight.constant = 0
//        questionTitleHeight.constant = 0
        gapButtons = []
        question = nil
        questionOptionsView?.answersCollectionView.reloadData()
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
    
    func calculateCellHeightFor(_ question: QuestionPostTest) {
        var questionBlockHeight: CGFloat = 80 // height for green question block without textview
        let answersFooterHeight: CGFloat = 33.0 // add item button
        let answersCollectionViewInsets: CGFloat = 16.0
        var minAnswersConteinerHeight: CGFloat = answersFooterHeight + answersCollectionViewInsets
        questionOptionsViewHeight.constant = 0

        switch question.type {
        case .gaps:
            // question textview that should be same as used in cell
            let questionTextViewWidth: CGFloat = self.frame.width - 50 - 50 - 16 - 16 - 16

            let questionTitleTextViewSize = questionTitleTextView.sizeThatFits(CGSize(width: questionTextViewWidth, height: CGFloat.greatestFiniteMagnitude))
            questionBlockHeight = questionBlockHeight + questionTitleTextViewSize.height
            
            questionTitleHeight.constant = questionTitleTextViewSize.height
            questionTitleTextView.lineTopConstraint.constant = questionTitleTextViewSize.height - questionTitleTextView.lineHeightConstraint.constant
            questionContainerHeight.constant = questionBlockHeight
            
        default:
            let questionTextViewWidth: CGFloat = self.frame.width - 50 - 50 - 16 - 16 - 16
            
            let questionTitleTextViewSize = questionTitleTextView.sizeThatFits(CGSize(width: questionTextViewWidth, height: CGFloat.greatestFiniteMagnitude))
            questionBlockHeight = questionBlockHeight + questionTitleTextViewSize.height
            
            questionTitleHeight.constant = questionTitleTextViewSize.height
            questionTitleTextView.lineTopConstraint.constant = questionTitleTextViewSize.height - questionTitleTextView.lineHeightConstraint.constant
            questionContainerHeight.constant = questionBlockHeight
            
            // answer textview that should be same as used in cell
            let answerTextView = UnderLinedTextView(frame: .zero, textContainer: nil)
            answerTextView.font = UIFont.systemFont(ofSize: 13)
            
            // calculate size for each answer
            for answer in question.answers {
                answerTextView.text = answer.title
                
                let answerTextViewWidth: CGFloat = self.frame.width - 50 - 50 - 16 - 16 - 25 - 16 - 8
                
                let answerTextViewSize = answerTextView.sizeThatFits(CGSize(width: answerTextViewWidth, height: CGFloat.greatestFiniteMagnitude))
                minAnswersConteinerHeight += answerTextViewSize.height

            }
            
            questionOptionsViewHeight.constant = minAnswersConteinerHeight
        }
    }
    
    func addGapButtons(for question: QuestionPostTest) {
        let questionWordsCount = questionTitleTextView.numberOfWords()
        
        for wordIndex in 0 ..< questionWordsCount {
            let word = questionTitleTextView.getWord(at: wordIndex)
            let wordRectInTextView = questionTitleTextView.getWordFrame(at: word.range)
            let wordRectInCell = questionTitleTextView.convert(wordRectInTextView, to: self)
            
            let buttonRect = CGRect(x: wordRectInCell.origin.x, y: wordRectInCell.origin.y - 20, width: wordRectInCell.width, height: 20.0)

            if question.missingWordsIndexes.contains(wordIndex) {
                let gapButton = GapButton(frame: buttonRect, gapWord: word.wordString, wordIndex: wordIndex, wordRange: word.range, wordIsMissing: true)
                gapButton.addTarget(self, action: #selector (setGapButtonStatus(_:)), for: .touchUpInside)
                addSubview(gapButton)
                gapButtons.append(gapButton)
            } else {
                let gapButton = GapButton(frame: buttonRect, gapWord: word.wordString, wordIndex: wordIndex, wordRange: word.range, wordIsMissing: false)
                gapButton.addTarget(self, action: #selector (setGapButtonStatus(_:)), for: .touchUpInside)
                addSubview(gapButton)
                gapButtons.append(gapButton)
            }
        }
    }
    
    func setGapButtonStatus(_ sender: GapButton) {
        sender.wordIsMissing = !sender.wordIsMissing
        question!.missingWordsIndexes = []
        
        gapButtons.forEach { button in
            if button.wordIsMissing {
                question!.missingWordsIndexes.append(button.wordIndex)
            }
        }
    }

}

extension QuizQuestionAnswersCell: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        
        switch textView {
        case questionTitleTextView:
            switch question!.type {
            
            case .gaps:
                for gapButton in gapButtons {
                    gapButton.removeFromSuperview()
                }
                gapButtons.removeAll()
                question!.gapAnswer = textView.text
                addGapButtons(for: question!)
            default:
                break
            }
            
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

extension QuizQuestionAnswersCell: RadioButtonsViewDelegate {
    
    func didUpdateCollectionViewLayout(view: QuizAnswersView) {
        questionOptionsViewHeight.constant = view.answersCollectionView.contentSize.height + 16
        ownerCollectionView?.performBatchUpdates(nil)
    }
    
}










