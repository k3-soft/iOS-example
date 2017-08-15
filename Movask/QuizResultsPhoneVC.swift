//
//  QuizResultsPhoneVC.swift
//  Movask
//
//  Created by Alina Yehorova on 14.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import UIKit

class QuizResultsPhoneVC: BasicVC {
    
    // Navigation bar
    @IBOutlet weak var quizTitleLabel: UILabel!
    @IBOutlet weak var quizDescriptionLabel: UILabel!
    
    // Summary view
    @IBOutlet weak var summaryView: UIView!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var completedLabel: UILabel!
    @IBOutlet weak var correctAnswersLabel: UILabel!
    @IBOutlet weak var myResultsLabel: UILabel!
    
    // Buttons
    @IBOutlet weak var backToStartButton: UIButton!
    @IBOutlet weak var redoButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var saveLabel: UILabel!
    
    // Collection
    @IBOutlet weak var resultsCollection: UICollectionView!
    
    // Data
    var quiz: QuizTest!
    var questionsList = [QuestionGetTest]()
    var pageNumber = 0
    
    // Collection settings
    
    let questionCellIdentifier = "ResultQuestionCell"
    let gapQuestionCellIdentifier = "ResultGapQuestionCell"
    
    var collectionLineSpacing: CGFloat {
        return 10.0
    }
    var collectionInsets: CGFloat {
        return 15.0
    }
    
    // MARK: - VC lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setResults()
        setCollectionView()
        setResults()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // For case loading screen in landscape
        // TODO: Check when it's not root vc, delete if needed
        resultsCollection.collectionViewLayout.invalidateLayout()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        // Resize cells content
        for cell in resultsCollection.visibleCells {
            if let questionCell = cell as? ResultQuestionCell {
                questionCell.reload(viewWidth: size.width)
            } else if let questionGapCell = cell as? ResultGapQuestionCell {
                questionGapCell.reloadStart(viewWidth: size.width)
            }
        }
        
        // Scroll to current question when rotate
        coordinator.animate(alongsideTransition: { [unowned self] _ in
            
            self.resultsCollection.scrollToItem(at: IndexPath(item: self.pageNumber, section: 0), at: .centeredHorizontally, animated: true)
            
            }, completion: { _ in
                for cell in self.resultsCollection.visibleCells {
                    if let questionGapCell = cell as? ResultGapQuestionCell {
                        questionGapCell.reloadEnd()
                    }
                }
        })
    }
    
    deinit {
        print("QuizResultsVC was deallocated")
    }
    
    // MARK: - Views settings
    
    func setNavigationBar() {
        
        quizTitleLabel.text = quiz.title
        quizDescriptionLabel.text = quiz.description
    }
    
    func setCollectionView() {
        
        resultsCollection.decelerationRate = UIScrollViewDecelerationRateFast
        
        let cellIdentifiers = [questionCellIdentifier, gapQuestionCellIdentifier]
        
        for identifier in cellIdentifiers {
            resultsCollection.register(UINib(nibName: identifier, bundle: nil),
                                       forCellWithReuseIdentifier: identifier)
        }
    }
    
    func setResults() {
        
        let correctAnswers = getCorrectAnswersCount()
        let questionsCount = questionsList.count
        
        correctAnswersLabel.text = "\(correctAnswers)/\(questionsCount) questions!"
        
        let result = ResultRating.getResult(correctAnswers: correctAnswers, totalAmount: questionsCount)
        
        resultLabel.text = result?.localized
    }
    
    func getCorrectAnswersCount() -> Int {
        
        var correctAnswers = 0
        
        for question in questionsList {
            
            switch question.type {
                
            case .checkmarks, .radiobuttons:
                for i in 0 ..< question.answers.count {
                    if !question.answers[i].isAccepted {
                        break
                    }
                    if i == question.answers.count - 1 {
                        correctAnswers += 1
                    }
                }
                
            case .gaps:
                for i in 0 ..< question.missingWords.count {
                    guard question.missingWords.count == question.userWords.count else { break }
                    if question.missingWords[i] != question.userWords[i] {
                        break
                    }
                    if i == question.missingWords.count - 1 {
                        correctAnswers += 1
                    }
                }
            }
        }
        
        return correctAnswers
    }
    
    // MARK: - Actions
    
    @IBAction func backToStart(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func redo(_ sender: UIButton) {
        print("Redo")
    }
    
    @IBAction func addToSaved(_ sender: UIButton) {
        print("Add to saved")
    }
}

extension QuizResultsPhoneVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return questionsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let question = questionsList[indexPath.row]
        
        switch question.type {
            
        case .checkmarks, .radiobuttons:
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: questionCellIdentifier, for: indexPath) as! ResultQuestionCell
            
            cell.setWithQuestion(question)
            
            return cell
            
        case .gaps:
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: gapQuestionCellIdentifier, for: indexPath) as! ResultGapQuestionCell
            
            cell.setWithQuestion(question)
            
            return cell
        }
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: collectionInsets,
                            left: collectionInsets + collectionLineSpacing,
                            bottom: collectionInsets + collectionLineSpacing,
                            right: collectionInsets + collectionLineSpacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (view.frame.size.width - collectionLineSpacing * 2 - (collectionInsets * 2 - 6)), height: ResultQuestionCell.cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return collectionLineSpacing
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if scrollView == resultsCollection {
            
            let visibleRect = CGRect(origin: resultsCollection.contentOffset, size: resultsCollection.bounds.size)
            let initialPinchPoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
            
            guard let currentIndexPath = resultsCollection.indexPathForItem(at: initialPinchPoint) else {
                pageNumber = 0
                return
            }
            
            pageNumber = currentIndexPath.item
        }
    }
}
