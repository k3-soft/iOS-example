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
    @IBOutlet weak var questionCounterLabel: UILabel!
    
    // Data
    var questionsList = [QuestionTest]()
    var pageNumber = 0
    
    // Flow
    var isScrollingEnable = false
    
    // Collection settings
    
    let questionCellIdentifier = "QuestionCell"
    
    let collectionLineSpacing: CGFloat = 10.0
    var collectionInsets: CGFloat = 15.0

    override func viewDidLoad() {
        super.viewDidLoad()

        setCollectionView()
        loadQuestions()
        setQuestionCounter()
    }

    // MARK: - Views settings
    
    func setCollectionView() {
        
        questionsCollection.decelerationRate = UIScrollViewDecelerationRateFast
        questionsCollection.isScrollEnabled = false
        
        questionsCollection.register(UINib(nibName: questionCellIdentifier, bundle: nil),
                                     forCellWithReuseIdentifier: questionCellIdentifier)
    }
    
    func setQuestionCounter() {
        
        questionCounterLabel.text = "\(pageNumber + 1)/\(questionsList.count)"
    }
    
    func scrollToQuestion(index: Int) {
        
        guard index < questionsList.count else { return }
        
        questionsCollection.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
        
        pageNumber = index
        
        setQuestionCounter()
    }
    
    // MARK: - Load data
    
    func loadQuestions() {
        
        questionsList = Array(repeating: QuestionTest(), count: 5)
    }
    
    // MARK: - Actions
    
    func nextQuestion() {
        print("Confirm did tap")
        
        scrollToQuestion(index: pageNumber + 1)
    }
    
    func skipQuestion() {
        print("Skip")
        
        scrollToQuestion(index: pageNumber + 1)
    }
}

extension QuizPhoneVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return questionsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: questionCellIdentifier, for: indexPath) as! QuestionCell
        
        let question = questionsList[indexPath.row]
        
        cell.setWithQuestion(question)
        
        // Set handlers
        
        cell.confirmHandler = { [unowned self] _ in
            self.nextQuestion()
        }
        
        cell.skipHandler = { [unowned self] _ in
            self.skipQuestion()
        }
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: collectionInsets * 3,
                            left: collectionInsets + collectionLineSpacing,
                            bottom: collectionInsets + collectionLineSpacing,
                            right: collectionInsets + collectionLineSpacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: (view.frame.size.width - collectionLineSpacing * 2 - (collectionInsets * 2 - 6)), height: QuestionCell.cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return collectionLineSpacing
    }
}
