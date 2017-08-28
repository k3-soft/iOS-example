//
//  QuizAnswersView.swift
//  Movask
//
//  Created by mac on 08.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import UIKit

protocol RadioButtonsViewDelegate: class {
    func didUpdateCollectionViewLayout(view: QuizAnswersView)
}

class QuizAnswersView: NibView {
    
    @IBOutlet weak var answersCollectionView: UICollectionView!
    
    let cellHeight: CGFloat = 33.0
    let answerCell = "QuizAnswerCell"
    
    weak var layoutDelegate: RadioButtonsViewDelegate?
    
    var selectedAnswerIndexPath = IndexPath(row: 0, section: 0)
    
    var question: QuestionPostTest! {
        didSet {
            setupCollectionView()
            answersCollectionView.reloadData()
            NotificationCenter.default.addObserver(self, selector: #selector(updateCollectionViewLayout), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        }
    }
    
    func setupCollectionView() {
        answersCollectionView.delegate = self
        answersCollectionView.dataSource = self
        
        answersCollectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: -8, right: 0)
        
        let flow = answersCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flow.sectionFootersPinToVisibleBounds = false
        
        answersCollectionView.register(UINib(nibName: answerCell, bundle: nil),
                                    forCellWithReuseIdentifier: answerCell)
        answersCollectionView.register(UINib(nibName: answerCell, bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: answerCell)
    }
    
    //MARK:- Actions
    
    func updateCollectionViewLayout() {
        self.answersCollectionView.collectionViewLayout.invalidateLayout()
        answersCollectionView.performBatchUpdates(nil, completion: { completed in
            self.layoutDelegate?.didUpdateCollectionViewLayout(view: self)
        })
    }
    
    func addAnswerVariant() {
        let newAnswer = AnswerTest(title: "", isCorrect: false)
        question.answers.append(newAnswer)
        
        self.answersCollectionView.insertItems(at: [IndexPath(row: self.question.answers.count - 1, section: 0)])

        self.answersCollectionView.collectionViewLayout.invalidateLayout()
        answersCollectionView.performBatchUpdates(nil, completion: { completed in
            self.layoutDelegate?.didUpdateCollectionViewLayout(view: self)
        })
    }
}

extension QuizAnswersView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return question.answers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionElementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: answerCell, for: indexPath) as! QuizAnswerCell
            
            footerView.answerCheckImageView.isHidden = true
            footerView.deleteAnswerButton.isHidden = true

            footerView.answerTextView.placeholder = "Add option"
            footerView.answerTextView.isEditable = false
            let view = UIView(frame: CGRect(x: 0, y: 0, width: footerView.frame.width, height: footerView.frame.height))
            view.backgroundColor = .clear
            footerView.addSubview(view)
            view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector (addAnswerVariant)))
            
            return footerView
            
        default:
            return UICollectionReusableView()
            //assert(false, "Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let question = question else { return }
        
        switch question.type {
        case .radiobuttons:
            let oldSelectedCell = collectionView.cellForItem(at: selectedAnswerIndexPath) as! QuizAnswerCell
            oldSelectedCell.selectedCell = false
            question.answers[selectedAnswerIndexPath.item].isSelected = false
            
            let newSelectedCell = collectionView.cellForItem(at: indexPath) as! QuizAnswerCell
            newSelectedCell.selectedCell = true
            question.answers[indexPath.item].isSelected = true

            selectedAnswerIndexPath = indexPath
            
        case .checkmarks:
            let newSelectedCell = collectionView.cellForItem(at: indexPath) as! QuizAnswerCell
            
            if question.answers[indexPath.row].isSelected {
                question.answers[indexPath.row].isSelected = false
                newSelectedCell.selectedCell = false
            } else {
                question.answers[indexPath.row].isSelected = true
                newSelectedCell.selectedCell = true
            }
            
        default: break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: answerCell, for: indexPath) as! QuizAnswerCell
        
        cell.answer = question.answers[indexPath.item]
        cell.selectionType = question?.type
        cell.delegate = self
        cell.ownerView = self
        cell.selectedCell = question.answers[indexPath.item].isSelected
        
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
            if let question = question, indexPath.item < question.answers.count {
                let answer = question.answers[indexPath.item]
                
                let textViewInsets: CGFloat = 16.0
                let answerTextViewWidth: CGFloat = self.frame.width - 8 - 25 - 8 - 8 - 25 - 8
                let answerTextViewHeight = answer.title.height(withFixedWidth: answerTextViewWidth, textAttributes: QuizAnswerCell.answerTextAttributes) + textViewInsets
                
                return CGSize(width: self.frame.width, height: answerTextViewHeight)
                
            } else {
                return CGSize(width: self.frame.width, height: 33.0)
            }
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
    
    func didTapDeleteButton(cell: QuizAnswerCell, sender: UIButton) {
        let point = answersCollectionView.convert(CGPoint.zero, from: sender)
        
        if let indexPath = answersCollectionView.indexPathForItem(at: point) {
            self.question.answers.remove(at: indexPath.item)
            
            self.answersCollectionView.performBatchUpdates({
                self.answersCollectionView.deleteItems(at: [indexPath])
            }, completion: { completed in
                self.answersCollectionView.reloadData()
                self.layoutDelegate?.didUpdateCollectionViewLayout(view: self)
            })
        }
    }
}
