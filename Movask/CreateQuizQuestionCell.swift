//
//  CreateQuizQuestionCell.swift
//  Movask
//
//  Created by mac on 07.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import UIKit

protocol QuizQuestionCellDelegate: class {
    func didTapDeleteQuestionButton(cell: CreateQuizQuestionCell, sender: UIButton)
}

class CreateQuizQuestionCell: UICollectionViewCell {
    
    @IBOutlet weak var questionIndexLabel: UILabel!
    @IBOutlet weak var dragButton: UIButton!
    
    @IBOutlet weak var questionTypeLabel: UILabel!
    @IBOutlet weak var qustionTypeDescriptionLabel: UILabel!
    
    @IBOutlet weak var questionContainer: UIView!
    @IBOutlet weak var questionContainerHeight: NSLayoutConstraint!
    
    @IBOutlet weak var questionTitleTextView: UnderLinedTextView!
    @IBOutlet weak var questionTitleTextViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var answersView: QuizAnswersView!
    @IBOutlet weak var answersViewHeight: NSLayoutConstraint!

    weak var delegate: QuizQuestionCellDelegate?
    weak var ownerCollectionView: UICollectionView?
    
    var gapButtons: [GapButton] = []

    static let gapsQuestionTextAttributes: [String: NSObject] = {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 30
        let font = UIFont.boldSystemFont(ofSize: 14)
        
        let attributes = [NSParagraphStyleAttributeName : style, NSFontAttributeName : font, NSForegroundColorAttributeName : UIColor.white]
        return attributes
    }()
    
    static let variantsQuestionTextAttributes: [String: NSObject] = {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 0
        let font = UIFont.boldSystemFont(ofSize: 14)
        
        let attributes = [NSParagraphStyleAttributeName : style, NSFontAttributeName : font, NSForegroundColorAttributeName : UIColor.white]
        return attributes
    }()
    
    var question: QuestionPostTest? {
        willSet {
            guard let question = newValue else { return }
            
            questionIndexLabel.text = "\(question.id + 1)."
            questionTypeLabel.text = question.type.description
            qustionTypeDescriptionLabel.text = question.type.instruction
            
            switch question.type {
            case .gaps:                
                questionTitleTextView.attributedText = NSAttributedString(string: question.gapAnswer, attributes: CreateQuizQuestionCell.gapsQuestionTextAttributes)
                
            case .checkmarks, .radiobuttons:
                questionTitleTextView.attributedText = NSAttributedString(string: question.question, attributes: CreateQuizQuestionCell.variantsQuestionTextAttributes)
                
                answersView.question = question
            }
        }
    }
    
    override func awakeFromNib() {
        questionTitleTextView.delegate = self
        answersView.layoutDelegate = self
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector (repositionQuestion(_:)))
        dragButton.addGestureRecognizer(panGesture)
    }
    
    override func prepareForReuse() {
        removeGapButtons()
    }
    
    @IBAction func deleteQuestionButtonTapped(_ sender: UIButton) {
        print("delete question tapped")
        delegate?.didTapDeleteQuestionButton(cell: self, sender: sender)
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
            if UIDevice.current.userInterfaceIdiom == .phone {
                ownerCollectionView.updateInteractiveMovementTargetPosition(CGPoint(x: ownerCollectionView.frame.width/2, y: gesture.location(in: ownerCollectionView).y + self.frame.height/2 - 8 - 50/2))
            } else {
                ownerCollectionView.updateInteractiveMovementTargetPosition(CGPoint(x: ownerCollectionView.frame.width/2, y: gesture.location(in: ownerCollectionView).y + self.frame.height/2 - 8 - 50 - 8 - 50/2))
            }
            
        case UIGestureRecognizerState.ended:
            ownerCollectionView.endInteractiveMovement()
        default:
            ownerCollectionView.cancelInteractiveMovement()
        }
    }

    func calculateCellHeightConstraintsFor(_ question: QuestionPostTest) {
        var questionBlockHeight: CGFloat = 80 // height for green question block without textview
        let answersFooterHeight: CGFloat = 33.0 // add item button
        let answersCollectionViewInsets: CGFloat = 16.0
        let textViewInsets: CGFloat = 16.0
        
        var answerTextViewWidth: CGFloat = 0

        if UIDevice.current.userInterfaceIdiom == .phone {
            answerTextViewWidth = self.frame.width - 8 - 8 - 25 - 8 - 8 - 25 - 8 - 8
        } else {
            answerTextViewWidth = self.frame.width - 8 - 50 - 8 - 8 - 25 - 8 - 8 - 25 - 8 - 8 - 50 - 8
        }
        
        var answersConteinerHeight: CGFloat = answersFooterHeight + answersCollectionViewInsets
        answersViewHeight.constant = 0

        switch question.type {
        case .gaps:
            let questionTitleTextViewSize = questionTitleTextView.sizeThatFits(CGSize(width: questionTitleTextView.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
            questionBlockHeight = questionBlockHeight + questionTitleTextViewSize.height
            
            questionTitleTextViewHeight.constant = questionTitleTextViewSize.height
            questionTitleTextView.lineTopConstraint.constant = questionTitleTextViewSize.height - questionTitleTextView.lineHeightConstraint.constant
            questionContainerHeight.constant = questionBlockHeight
            
        default:
            let questionTitleTextViewSize = questionTitleTextView.sizeThatFits(CGSize(width: questionTitleTextView.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
            questionBlockHeight = questionBlockHeight + questionTitleTextViewSize.height
            
            questionTitleTextViewHeight.constant = questionTitleTextViewSize.height
            questionTitleTextView.lineTopConstraint.constant = questionTitleTextViewSize.height - questionTitleTextView.lineHeightConstraint.constant
            questionContainerHeight.constant = questionBlockHeight
            
            // calculate size for each answer
            for answer in question.answers {
                let answerTextViewHeight = answer.title.height(withFixedWidth: answerTextViewWidth, textAttributes: QuizAnswerCell.answerTextAttributes) + textViewInsets
                answersConteinerHeight += answerTextViewHeight
            }
            answersViewHeight.constant = answersConteinerHeight
        }
    }
    
    func addGapButtons(for question: QuestionPostTest) {
        let questionWordsCount = questionTitleTextView.numberOfWords()
        removeGapButtons()
        self.layoutIfNeeded()
        
        for wordIndex in 0 ..< questionWordsCount {
            let word = questionTitleTextView.getWord(at: wordIndex)
            let wordRectInTextView = questionTitleTextView.getWordFrame(at: word.range)
            let wordRectInCell = questionTitleTextView.convert(wordRectInTextView, to: self)
            
            let buttonRect = CGRect(x: wordRectInCell.origin.x - 1, y: wordRectInCell.origin.y - 20, width: wordRectInCell.width + 2, height: 20.0)

            var gapButton = GapButton()

            if question.missingWordsIndexes.contains(wordIndex) {
                gapButton = GapButton(frame: buttonRect, gapWord: word.wordString, wordIndex: wordIndex, wordRange: word.range, wordIsMissing: true)
                
                questionTitleTextView.hightLightWordAt(gapButton.wordIndex)

            } else {
                gapButton = GapButton(frame: buttonRect, gapWord: word.wordString, wordIndex: wordIndex, wordRange: word.range, wordIsMissing: false)
            }
            
            gapButton.addTarget(self, action: #selector (setGapButtonStatus(_:)), for: .touchUpInside)
            addSubview(gapButton)
            gapButtons.append(gapButton)
        }
    }
    
    func removeGapButtons() {
        for gapButton in gapButtons {
            gapButton.removeFromSuperview()
        }
        gapButtons.removeAll()
    }
    
    func setGapButtonStatus(_ sender: GapButton) {
        sender.isSelected = !sender.isSelected
        sender.setNeedsDisplay()

        if sender.isSelected {
            questionTitleTextView.hightLightWordAt(sender.wordIndex)
        } else {
            questionTitleTextView.removeHightLightWordAt(sender.wordIndex)
        }
        
        question!.missingWordsIndexes = []
        
        gapButtons.forEach { gap in
            if gap.isSelected {
                question!.missingWordsIndexes.append(gap.wordIndex)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        guard let question = question else { return }
        calculateCellHeightConstraintsFor(question)

        switch question.type {
        case .gaps:
            addGapButtons(for: question)
        default:
            break
        }
    }
}

extension CreateQuizQuestionCell: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        
        switch textView {
        case questionTitleTextView:
            
            switch question!.type {
            case .gaps:
                question!.gapAnswer = textView.text
                addGapButtons(for: question!)
            case .checkmarks, .radiobuttons:
                question!.question = textView.text
            }
            
            // update textview height
            questionTitleTextViewHeight.constant = newSize.height
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
    
}

extension CreateQuizQuestionCell: RadioButtonsViewDelegate {
    
    func didUpdateCollectionViewLayout(view: QuizAnswersView) {
        answersViewHeight.constant = view.answersCollectionView.contentSize.height + 16
        ownerCollectionView?.performBatchUpdates(nil)
    }
    
}










