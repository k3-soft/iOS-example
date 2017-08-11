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
    
    let maxHeightVideoView: CGFloat = 440.0
    let minHeightVideoView: CGFloat = 165.0
    
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
    @IBOutlet weak var videoPlayer: ASPVideoPlayer!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var centerXMovieView: NSLayoutConstraint!

    var replayButton: ReplayButton?
    
    var replayButtonFrame: CGRect {
        return CGRect(x: movieView.frame.maxX + 10.0, y: movieView.frame.midY - (40.0 / 2), width: 145.0, height: 40.0)
    }

    // Questions view
    @IBOutlet weak var questionsCollection: UICollectionView!
    @IBOutlet weak var questionCounterLabel: UILabel!
    
    // Data
    var quiz = QuizTest()
    var questionsList = [QuestionTest]()
    var pageNumber = 0
    
    // Flow
    var isQuizStarted = false
    var isMovieOpen = true
    
    // Collection settings
    
    let questionCellIdentifier = "QuestionCell"
    let gapQuestionCellIdentifier = "GapQuestionCell"
    
    let collectionLineSpacing: CGFloat = 10.0
    var collectionInsets: CGFloat = 15.0

    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        guard index < questionsList.count else { return }
        
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
        
        guard !isMovieOpen else { return }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.replayButton?.center.y -= 50.0
            self.replayButton?.alpha = 0.0
            
        }) { _ in
            
            self.isMovieOpen = true
            
            self.videoPlayer?.unhideControls()
        
            self.replayButton?.removeFromSuperview()
            self.replayButton = nil
            
            self.heightTopView.constant = self.maxHeightVideoView
            self.centerXMovieView.constant = 0.0
            
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            }) { _ in
                self.togglePlay()
            }
        }
    }
    
    func hideMovie() {
        
        guard isMovieOpen else { return }
        
        videoPlayer?.hideControlsTotally()

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
    
    func togglePlay() {
        
        videoPlayer?.videoPlayerView.playVideo()
        videoPlayer?.hideControls()
        videoPlayer?.videoPlayerControls.togglePlay()
    }
    
    // MARK: - Load data
    
    func loadQuestions() {
        
        questionsList = [QuestionTest(type: .gaps),
                         QuestionTest(type: .checkmarks),
                         QuestionTest(type: .radiobuttons),
                         QuestionTest(type: .checkmarks),
                         QuestionTest(type: .radiobuttons),
                         QuestionTest(type: .checkmarks)]
        
        questionsCollection.reloadData()
    }
    
    // MARK: - Actions
    
    @IBAction func startMovie(_ sender: UIButton) {
        
        topStartView.constant = -startView.bounds.height
        
        UIView.animate(withDuration: 0.3, animations: {
            self.topView.layoutIfNeeded()
        }) { _ in
            self.startView.alpha = 0.0
            
            self.isQuizStarted = true
            self.visibleCellButtonsEnabled(true)
            self.videoPlayer.unhideControls()
            self.togglePlay()
        }
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

extension QuizPhoneVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
