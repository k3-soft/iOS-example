//
//  RadioButtonsView.swift
//  Movask
//
//  Created by mac on 08.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import UIKit

protocol RadioButtonsViewDelegate: class {
    func radioWasSelectedOn(view: RadioButtonsView, with option: AnswerTest)
    func answerVariantWasAdded(view: RadioButtonsView)
    func didUpdateCollectionViewLayout(view: RadioButtonsView)
}

class RadioButtonsView: NibView {
    
    @IBOutlet weak var answersCollectionViewView: UICollectionView!
    
    let cellHeight: CGFloat = 30.0
    
    let answerCell = "RadioCell"
    
    weak var delegate: RadioButtonsViewDelegate?
    
    var answerVariants: [AnswerTest] = []
    var selectedIndexPath = IndexPath(row: 0, section: 0)
    
    var selectedItem: AnswerTest? {
        if selectedIndexPath.row < answerVariants.count {
            return answerVariants[selectedIndexPath.row]
        } else {
            return nil
        }
    }
    
    override func setupViews() {
        setupCollectionView()
    }
    
    func setupCollectionView() {
        answersCollectionViewView.delegate = self
        answersCollectionViewView.dataSource = self
//        answersCollectionViewView.isScrollEnabled = false
        
        answersCollectionViewView.contentInset = UIEdgeInsets(top: 8, left: 8, bottom: -8, right: -8)
        
        let flow = answersCollectionViewView.collectionViewLayout as! UICollectionViewFlowLayout
        flow.sectionFootersPinToVisibleBounds = false
        
        answersCollectionViewView.register(UINib(nibName: answerCell, bundle: nil),
                                    forCellWithReuseIdentifier: answerCell)
        answersCollectionViewView.register(UINib(nibName: answerCell, bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: answerCell)
    }
    
    //MARK:- Actions
    
    func updateCollectionViewLayout() {
        self.answersCollectionViewView.collectionViewLayout.invalidateLayout()
        answersCollectionViewView.performBatchUpdates(nil, completion: { completed in
            self.delegate?.didUpdateCollectionViewLayout(view: self)
        })

    }
    
    func addAnswerVariant() {
        answerVariants.append(AnswerTest(title: ""))
        
        self.answersCollectionViewView.insertItems(at: [IndexPath(row: self.answerVariants.count-1, section: 0)])

        self.answersCollectionViewView.collectionViewLayout.invalidateLayout()
        answersCollectionViewView.performBatchUpdates(nil, completion: { completed in
            self.delegate?.didUpdateCollectionViewLayout(view: self)
            self.delegate?.answerVariantWasAdded(view: self)
        })
    }
    
}

extension RadioButtonsView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return answerVariants.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionElementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: answerCell, for: indexPath) as! RadioCell
            
            footerView.radioTextView.placeholder = "Add option"
            footerView.radioTextView.isEditable = false
            footerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector (addAnswerVariant)))

            return footerView
            
        default:
            assert(false, "Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let oldSelectedCell = collectionView.cellForItem(at: selectedIndexPath) as! RadioCell
        oldSelectedCell.selectedCell = false
        
        let newSelectedCell = collectionView.cellForItem(at: indexPath) as! RadioCell
        newSelectedCell.selectedCell = true
        delegate?.radioWasSelectedOn(view: self, with: answerVariants[indexPath.row])
        
        selectedIndexPath = indexPath
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: answerCell, for: indexPath) as! RadioCell
        
        cell.radioTextView.text = answerVariants[indexPath.row].title
        cell.ownerView = self
        
        if indexPath == selectedIndexPath {
            cell.selectedCell = true
        } else {
            cell.selectedCell = false
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let item = collectionView.cellForItem(at: indexPath) as? RadioCell {
            let questionConteinerHeight = item.radioTextViewHeight.constant
            return CGSize(width: self.frame.width, height: questionConteinerHeight)
        } else {
            return CGSize(width: self.frame.width, height: 30)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: self.frame.width, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
