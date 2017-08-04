//
//  QuizPhoneVC.swift
//  Movask
//
//  Created by Alina Yehorova on 04.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import UIKit

class QuizPhoneVC: BasicVC {
    
    @IBOutlet weak var questionsCollection: UICollectionView!
    
    // Data
    var questionsList = [QuestionTest]()
    var pageNumber = 0
    
    let questionCellIdentifier = "QuestionCell"
    
    let collectionLineSpacing: CGFloat = 15.0
    var collectionInsets: CGFloat = 20.0

    override func viewDidLoad() {
        super.viewDidLoad()

        setCollectionView()
        loadQuestions()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        
//        let sideInset = (self.view.frame.width - self.view.frame.height * 0.52)/2
//        questionsCollection.contentInset = UIEdgeInsets(top: 0, left: sideInset, bottom: 0, right: sideInset)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
 
//        questionsCollection.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: false)
    }

    // MARK: - Views settings
    
    func setCollectionView() {
        
        questionsCollection.decelerationRate = UIScrollViewDecelerationRateFast
        //automaticallyAdjustsScrollViewInsets = false
        
        questionsCollection.register(UINib(nibName: questionCellIdentifier, bundle: nil),
                                     forCellWithReuseIdentifier: questionCellIdentifier)
    }
    
    // MARK: - Load data
    
    func loadQuestions() {
        
        questionsList = Array(repeating: QuestionTest(), count: 20)
    }
    
    // MARK: - Actions
    

}

extension QuizPhoneVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return questionsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: questionCellIdentifier, for: indexPath) as! QuestionCell
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: collectionInsets,
                            left: collectionInsets + collectionLineSpacing,
                            bottom: collectionInsets,
                            right: collectionInsets + collectionLineSpacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: (view.frame.size.width - collectionLineSpacing * 2 - collectionInsets * 2), height: QuestionCell.cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return collectionLineSpacing
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == questionsCollection {
            
            let initialPinchPoint = CGPoint(x: questionsCollection.center.x + questionsCollection.contentOffset.x, y: questionsCollection.center.y + questionsCollection.contentOffset.y)
            
            guard let currentIndexPath = questionsCollection.indexPathForItem(at: initialPinchPoint) else {
                pageNumber = 0
                return
            }
            
            pageNumber = currentIndexPath.item
        }
    }
}
