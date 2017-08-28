//
//  QuestionTypesDropDown.swift
//  Movask
//
//  Created by mac on 28.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import UIKit
import YNDropDownMenu

protocol QuestionTypesDropDownDelegate: class {
    func didSelectQuestionType(in menu: QuestionTypesDropDown, at senderIndexPath: IndexPath?)
}

class QuestionTypesDropDown: NibView {

    @IBOutlet weak var questionTypesCollectionView: UICollectionView!
    weak var delegate: QuestionTypesDropDownDelegate?
    
    let cellId = "QuestionTypeCell"
    var selectedType: QuestionType?
    var senderIndexPath: IndexPath?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, selectedType: QuestionType?, senderIndexPath: IndexPath?) {
        self.init(frame: frame)
        self.selectedType = selectedType
        self.senderIndexPath = senderIndexPath
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupViews() {
        
        questionTypesCollectionView.delegate = self
        questionTypesCollectionView.dataSource = self
        questionTypesCollectionView.isScrollEnabled = false
        
        questionTypesCollectionView.register(UINib(nibName: cellId, bundle: nil),
                                       forCellWithReuseIdentifier: cellId)

    }
    
}

extension QuestionTypesDropDown: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allQuestionTypes.count
    }
        
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedType = allQuestionTypes[indexPath.item]
        delegate?.didSelectQuestionType(in: self, at: senderIndexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! QuestionTypeCell
        cell.typeLabel.text = allQuestionTypes[indexPath.item].description
        print(allQuestionTypes[indexPath.item].description)
        if allQuestionTypes[indexPath.item].description == selectedType?.description {
            cell.selectedCell = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        return CGSize(width: self.frame.width, height: 41)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    
}
