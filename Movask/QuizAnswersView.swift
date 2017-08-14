//
//  QuizAnswersView.swift
//  Movask
//
//  Created by mac on 08.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import UIKit

protocol AnswersViewModificationDelegate: class {
    func didSelect(answer: AnswerTest, for question: QuestionTest?)
    func didFinishEditing(answer: AnswerTest, for question: QuestionTest?, withText text: String)
    func didAdd(answer: AnswerTest, for question: QuestionTest?)
}

protocol RadioButtonsViewDelegate: class {
    func didUpdateCollectionViewLayout(view: QuizAnswersView)
}

class QuizAnswersView: NibView {
    
    @IBOutlet weak var answersCollectionView: UICollectionView!
    
    let cellHeight: CGFloat = 33.0
    let answerCell = "QuizAnswerCell"
    
    weak var layoutDelegate: RadioButtonsViewDelegate?
    weak var modificationDelegate: AnswersViewModificationDelegate?
    
    var answerVariants: [AnswerTest] = []
    var selectedAnswerIndexPath = IndexPath(row: 0, section: 0)
    
    var question: QuestionTest? {
        didSet {
            guard let question = question else { return }
            answerVariants = question.answers
        }
    }
    
    override func setupViews() {
        setupCollectionView()
//        NotificationCenter.default.addObserver(self, selector: #selector (updateCollectionView), name: Notification.Name("orientationChanged"), object: nil)
    }
    
    func setupCollectionView() {
        answersCollectionView.delegate = self
        answersCollectionView.dataSource = self
        
        answersCollectionView.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: -8, right: -8)
        
        let flow = answersCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flow.sectionFootersPinToVisibleBounds = false
        
        answersCollectionView.register(UINib(nibName: answerCell, bundle: nil),
                                    forCellWithReuseIdentifier: answerCell)
        answersCollectionView.register(UINib(nibName: answerCell, bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: answerCell)
    }
    
    //MARK:- Actions
    
//    func updateCollectionView() {
//        answersCollectionViewView.performBatchUpdates(nil, completion: { completed in })
//    }
    
    func updateCollectionViewLayout() {
        self.answersCollectionView.collectionViewLayout.invalidateLayout()
        answersCollectionView.performBatchUpdates(nil, completion: { completed in
            self.layoutDelegate?.didUpdateCollectionViewLayout(view: self)
        })

    }
    
    func addAnswerVariant() {
        let newAnswer = AnswerTest(title: "")
        answerVariants.append(newAnswer)
        
        self.answersCollectionView.insertItems(at: [IndexPath(row: self.answerVariants.count-1, section: 0)])

        self.answersCollectionView.collectionViewLayout.invalidateLayout()
        answersCollectionView.performBatchUpdates(nil, completion: { completed in
            self.layoutDelegate?.didUpdateCollectionViewLayout(view: self)
            self.modificationDelegate?.didAdd(answer: newAnswer, for: self.question)
        })
    }
    
}

extension QuizAnswersView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return answerVariants.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionElementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: answerCell, for: indexPath) as! QuizAnswerCell
            
            footerView.answerCheckImageView.isHidden = true
            footerView.answerTextView.placeholder = "Add option"
            footerView.answerTextView.isEditable = false
            footerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector (addAnswerVariant)))

            return footerView
            
        default:
            assert(false, "Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let question = question else { return }
        
        switch question.type {
        case .radiobuttons:
            let oldSelectedCell = collectionView.cellForItem(at: selectedAnswerIndexPath) as! QuizAnswerCell
            oldSelectedCell.selectedCell = false
            
            let newSelectedCell = collectionView.cellForItem(at: indexPath) as! QuizAnswerCell
            newSelectedCell.selectedCell = true
            
            answerVariants[indexPath.row].isSelected = true
            selectedAnswerIndexPath = indexPath
            
        case .checkmarks:
            let newSelectedCell = collectionView.cellForItem(at: indexPath) as! QuizAnswerCell
            
            if answerVariants[indexPath.row].isSelected {
                answerVariants[indexPath.row].isSelected = false
                newSelectedCell.selectedCell = false
            } else {
                answerVariants[indexPath.row].isSelected = true
                newSelectedCell.selectedCell = true
            }
            
        default: break
        }
        modificationDelegate?.didSelect(answer: answerVariants[indexPath.row], for: question)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: answerCell, for: indexPath) as! QuizAnswerCell
        
        cell.answer = answerVariants[indexPath.item]
        cell.selectionType = question?.type
        cell.delegate = self
        cell.ownerView = self
        cell.selectedCell = answerVariants[indexPath.item].isSelected
        
        if cell.selectedCell {
            selectedAnswerIndexPath = indexPath
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let answerCell = collectionView.cellForItem(at: indexPath) as? QuizAnswerCell {
            let questionConteinerHeight = answerCell.answerTextViewHeight.constant
            return CGSize(width: self.frame.width, height: questionConteinerHeight)
        } else {
            // answer textview that should be same as used in cell
            let answerTextView = UnderLinedTextView(frame: .zero, textContainer: nil)
            answerTextView.font = UIFont.systemFont(ofSize: 13)
            
            if let question = question, indexPath.item < question.answers.count {
                let answer = question.answers[indexPath.item]
                answerTextView.text = answer.title
            } else {
                answerTextView.text = ""
            }

            let answerTextViewWidth: CGFloat = self.frame.width - 25 - 16 - 8
            
            let answerTextViewSize = answerTextView.sizeThatFits(CGSize(width: answerTextViewWidth, height: CGFloat.greatestFiniteMagnitude))
            
            return CGSize(width: self.frame.width, height: answerTextViewSize.height)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: self.frame.width, height: 33)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

extension QuizAnswersView: RadioCellDelegate {
    func didFinishEditingAnswer(cell: QuizAnswerCell) {
        guard let answer = cell.answer else { return }
        modificationDelegate?.didFinishEditing(answer: answer, for: question, withText: cell.answerTextView.text)
    }
}
