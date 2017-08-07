//
//  QuizPhoneVC.swift
//  Movask
//
//  Created by Alina Yehorova on 04.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import UIKit

class QuizPhoneVC: BasicVC {
    
    // Top view
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var heightTopView: NSLayoutConstraint!
    
    let maxHeightVideoView: CGFloat = 450.0
    let minHeightVideoView: CGFloat = 175.0
    
    // Navigation bar
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    @IBOutlet weak var backButton: UIButton! {
        didSet {
            backButton.touchAreaEdgeInsets = .init(top: -10, left: -10, bottom: -10, right: -10)
        }
    }
    
    // Start view
    
    @IBOutlet weak var starImage: UIImageView!
    @IBOutlet weak var questionImage: UIImageView!
    @IBOutlet weak var cupImage: UIImageView!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var questionsLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var startView: UIView!
    @IBOutlet weak var heightStartView: NSLayoutConstraint!
    @IBOutlet weak var topStartView: NSLayoutConstraint!
    
    // Video view
    
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var movieView: UIView!
    
    @IBOutlet weak var centerXMovieView: NSLayoutConstraint!
    
    var replayButton: ReplayButton?
    
    var replayButtonFrame: CGRect {
        return CGRect(x: movieView.frame.maxX + 10.0, y: movieView.frame.midY - (40.0 / 2), width: 145.0, height: 40.0)
    }

    // Questions view
    @IBOutlet weak var questionsCollection: UICollectionView!
    @IBOutlet weak var questionCounterLabel: UILabel!
    
    // Data
    var questionsList = [QuestionTest]()
    var pageNumber = 0
    
    // Flow
    var isQuizStarted = false
    var isMovieOpen = true
    
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // For case loading screen in landscape
        // TODO: Check when it's not root vc, delete if needed
        questionsCollection.collectionViewLayout.invalidateLayout()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        // Scroll to current question when rotate
        coordinator.animate(alongsideTransition: { [unowned self] _ in
            self.replayButton?.frame = self.replayButtonFrame
            self.questionsCollection.scrollToItem(at: IndexPath(item: self.pageNumber, section: 0), at: .centeredHorizontally, animated: true)
        }, completion: nil)
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
    
    func initiateReplayButton() {
        
        replayButton = ReplayButton(frame: replayButtonFrame)
        replayButton?.replay.addTarget(self, action: #selector(replayVideo), for: .touchUpInside)
        replayButton?.center.y -= 50.0
        replayButton?.alpha = 0.0
        
        videoView.addSubview(replayButton!)
    }
    
    // MARK: - Movie actions
    
    func openMovie() {
        
        guard !isMovieOpen else { return }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.replayButton?.center.y -= 50.0
            self.replayButton?.alpha = 0.0
            
        }) { _ in
            
            self.isMovieOpen = true
        
            self.replayButton?.removeFromSuperview()
            self.replayButton = nil
            
            self.heightTopView.constant = self.maxHeightVideoView
            self.centerXMovieView.constant = 0.0
            
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func hideMovie() {
        
        guard isMovieOpen else { return }

        heightTopView.constant = minHeightVideoView
        centerXMovieView.constant = -75.0
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            
        }) { _ in
            
            self.isMovieOpen = false
            
            self.initiateReplayButton()
            UIView.animate(withDuration: 0.3, animations: {
                self.replayButton?.center.y += 50.0
                self.replayButton?.alpha = 1.0
            })
        }
    }
    
    func replayVideo() {
        
        openMovie()
    }
    
    // MARK: - Load data
    
    func loadQuestions() {
        
        questionsList = [QuestionTest(type: .checkmarks),
                         QuestionTest(type: .radiobuttons),
                         QuestionTest(type: .checkmarks),
                         QuestionTest(type: .radiobuttons),
                         QuestionTest(type: .checkmarks)]
    }
    
    // MARK: - Actions
    
    @IBAction func startMovie(_ sender: UIButton) {
        
        topStartView.constant = -startView.bounds.height
        
        UIView.animate(withDuration: 0.3, animations: {
            self.topView.layoutIfNeeded()
        }) { _ in
            self.startView.alpha = 0.0
            
            // start movie
            self.isQuizStarted = true
        }
    }
    
    func nextQuestion() {
        
//        guard isQuizStarted else { return }
//        
//        scrollToQuestion(index: pageNumber + 1)
        
        hideMovie()
    }
    
    func skipQuestion() {
        
        guard isQuizStarted else { return }
        
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
        print(view.frame.size.width)
        return CGSize(width: (view.frame.size.width - collectionLineSpacing * 2 - (collectionInsets * 2 - 6)), height: QuestionCell.cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return collectionLineSpacing
    }
}
