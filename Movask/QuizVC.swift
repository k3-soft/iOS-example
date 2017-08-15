//
//  QuizVC.swift
//  Movask
//
//  Created by Alina Yehorova on 11.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import UIKit

class QuizVC: BasicVC {
    
    // Top view
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var heightTopView: NSLayoutConstraint!
    
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
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var questionsLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    
    // Video view
    
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var movieView: UIView!
    @IBOutlet weak var videoPlayer: ASPVideoPlayer!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var replayButton: ReplayButton?
    
    var replayButtonFrame: CGRect {
        // Need to be overriden
        return CGRect()
    }
    
    // Questions view
    @IBOutlet weak var questionsCollection: UICollectionView!
    @IBOutlet weak var questionCounterLabel: UILabel!
    
    // Data
    var quiz: QuizTest!
    var questionsList = [QuestionGetTest]()
    var pageNumber = 0
    
    // Flow
    var isQuizStarted = false
    var isMovieOpen = true
    
    // Collection settings
    
    let questionCellIdentifier = "QuestionCell"
    let gapQuestionCellIdentifier = "GapQuestionCell"
    
    var collectionLineSpacing: CGFloat {
        // Need to be overriden
        return 0.0
    }
    var collectionInsets: CGFloat {
        // Need to be overriden
        return 0.0
    }
    
    // MARK: - VC lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setCollectionView()
        loadQuestions()
        setQuestionCounter()
        setVideoPlayer()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // For case loading screen in landscape
        // TODO: Check when it's not root vc, delete if needed
        questionsCollection.collectionViewLayout.invalidateLayout()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        // Resize cells content
        for cell in questionsCollection.visibleCells {
            if let questionCell = cell as? QuestionCell {
                questionCell.reload(viewWidth: size.width)
            } else if let questionGapCell = cell as? GapQuestionCell {
                questionGapCell.reload(viewWidth: size.width)
            }
        }
        
        // Scroll to current question when rotate
        coordinator.animate(alongsideTransition: { [unowned self] _ in
            
            self.replayButton?.frame = self.replayButtonFrame

            self.questionsCollection.scrollToItem(at: IndexPath(item: self.pageNumber, section: 0), at: .centeredHorizontally, animated: true)
            
        }, completion: { _ in
            for cell in self.questionsCollection.visibleCells {
                if let questionGapCell = cell as? GapQuestionCell {
                    questionGapCell.layoutGaps()
                }
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        videoPlayer.videoPlayerView.stopVideo()
    }
    
    deinit {
        print("QuizVC was deallocated")
    }
    
    // MARK: - Views settings
    
    func setNavigationBar() {
        
        titleLabel.text = quiz.title
        descriptionLabel.text = quiz.description
    }
    
    func setCollectionView() {
        
        questionsCollection.decelerationRate = UIScrollViewDecelerationRateFast
        questionsCollection.isScrollEnabled = false
        
        let cellIdentifiers = [questionCellIdentifier, gapQuestionCellIdentifier]
        
        for identifier in cellIdentifiers {
            questionsCollection.register(UINib(nibName: identifier, bundle: nil),
                                         forCellWithReuseIdentifier: identifier)
        }
    }
    
    func setQuestionCounter() {
        
        questionCounterLabel.text = "\(pageNumber + 1)/\(questionsList.count)"
    }
    
    func scrollToQuestion(index: Int) {
        
        guard index < questionsList.count else {
            
            // Last question, show results
            
            var quizResultsVC: QuizResultsVC?
            
            if UIDevice.current.userInterfaceIdiom == .phone {
                quizResultsVC = QuizResultsPhoneVC()
            } else {
                quizResultsVC = QuizResultsPadVC()
            }
    
            quizResultsVC!.quiz = quiz
            quizResultsVC!.questionsList = questionsList
            
            navigationController?.pushViewController(quizResultsVC!, animated: true)
            
            return
        }
        
        questionsCollection.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
        
        pageNumber = index
        
        setQuestionCounter()
    }
    
    func setVideoPlayer() {
        
        guard let url = URL(string: quiz.videoPath) else { return }
        
        activityIndicator.startAnimating()
        
        videoPlayer?.videoURLs = [url]
        videoPlayer?.gravity = .aspectFill
        videoPlayer?.shouldLoop = false
        videoPlayer?.tintColor = UIColor.white
        videoPlayer?.hideControlsTotally()
        
        videoPlayer?.videoPlayerView.finishedVideo = { [unowned self] in
            self.hideMovie()
        }
        
        videoPlayer?.videoPlayerView.readyToPlayVideo = { [unowned self] in
            self.activityIndicator.stopAnimating()
        }
    }
    
    func initiateReplayButton() {
        
        replayButton = ReplayButton(frame: replayButtonFrame)
        replayButton?.replay.addTarget(self, action: #selector(replayVideo), for: .touchUpInside)
        replayButton?.center.y -= 50.0
        replayButton?.alpha = 0.0
        
        videoView.addSubview(replayButton!)
    }
    
    func visibleCellButtonsEnabled(_ enabled: Bool) {
        
        for cell in questionsCollection.visibleCells {
            if let questionCell = cell as? QuestionCellHandler {
                questionCell.buttonsEnabled(enabled)
            }
        }
    }
    
    // MARK: - Movie actions
    
    func openMovie() {
        // Need to be overriden
    }

    func hideMovie() {
        // Need to be overriden
    }
    
    func replayVideo() {
        openMovie()
    }
    
    func togglePlay() {
        
        videoPlayer?.videoPlayerView.playVideo()
        videoPlayer?.hideControls()
        videoPlayer?.videoPlayerControls.togglePlay()
    }
    
    // MARK: - Load data
    
    func loadQuestions() {
        
        questionsList = [QuestionGetTest(type: .gaps),
                         QuestionGetTest(type: .checkmarks),
                         QuestionGetTest(type: .radiobuttons),
                         QuestionGetTest(type: .gaps),
                         QuestionGetTest(type: .radiobuttons),
                         QuestionGetTest(type: .checkmarks)]
        
        questionsCollection.reloadData()
    }
    
    // MARK: - Actions
    
    @IBAction func startMovie(_ sender: UIButton) {
        // Need to be overriden
    }
    
    @IBAction func back(_ sender: UIButton) {
        super.backDidTap()
    }
    
    func nextQuestion() {
        scrollToQuestion(index: pageNumber + 1)
    }
    
    func skipQuestion() {
        scrollToQuestion(index: pageNumber + 1)
    }
}

extension QuizVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return questionsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let question = questionsList[indexPath.row]
        
        var cell: QuestionCellHandler!
        
        switch question.type {
            
        case .checkmarks, .radiobuttons:
            
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: questionCellIdentifier, for: indexPath) as! QuestionCell
            
            (cell as! QuestionCell).setWithQuestion(question)
            
        case .gaps:
            
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: gapQuestionCellIdentifier, for: indexPath) as! GapQuestionCell
            
            (cell! as! GapQuestionCell).setWithQuestion(question)
        }
        
        // Set buttons
        
        cell.buttonsEnabled(isQuizStarted)
        
        // Set handlers
        
        cell!.confirmHandler = { [unowned self] _ in
            self.nextQuestion()
        }
        
        cell!.skipHandler = { [unowned self] _ in
            self.skipQuestion()
        }
        
        return cell as! UICollectionViewCell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        // Need to be overriden
        return UIEdgeInsets()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Need to be overriden
        return CGSize()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return collectionLineSpacing
    }
}
