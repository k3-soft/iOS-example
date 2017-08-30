//
//  QuizPhoneVC.swift
//  Movask
//
//  Created by Alina Yehorova on 04.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import UIKit

class QuizPhoneVC: QuizVC {
    
    // Top view
    
    let maxHeightVideoView: CGFloat = 440.0
    let minHeightVideoView: CGFloat = 165.0
    
    // Start view
    
    @IBOutlet weak var cupImage: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var startView: UIView!
    @IBOutlet weak var heightStartView: NSLayoutConstraint!
    @IBOutlet weak var topStartView: NSLayoutConstraint!
    
    // Video view
    
    @IBOutlet weak var centerXMovieView: NSLayoutConstraint!
    
    override var replayButtonFrame: CGRect {
        return CGRect(x: movieView.frame.maxX + 10.0, y: movieView.frame.midY - (40.0 / 2), width: 145.0, height: 40.0)
    }
    
    // Collection settings
    
    override var collectionLineSpacing: CGFloat {
        return 10.0
    }
    override var collectionInsets: CGFloat {
        return 15.0
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }

    // MARK: - Movie actions
    
    override func openMovie() {
        super.openMovie()
        
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
                self.playerLayer?.frame = self.movieView.bounds
            }) { _ in
                self.togglePlay()
            }
        }
    }
    
    override func hideMovie() {
        super.hideMovie()
        
        guard isMovieOpen else { return }

        heightTopView.constant = minHeightVideoView
        centerXMovieView.constant = -75.0
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            self.playerLayer?.frame = self.movieView.bounds
            
        }) { _ in
            
            self.isMovieOpen = false
            
            self.initiateReplayButton()
            UIView.animate(withDuration: 0.3, animations: {
                self.replayButton?.center.y += 50.0
                self.replayButton?.alpha = 1.0
            })
        }
    }
    
    // MARK: - Actions
    
    @IBAction override func startMovie(_ sender: UIButton) {
        super.startMovie(sender)
        
        topStartView.constant = -startView.bounds.height
        
        UIView.animate(withDuration: 0.3, animations: {
            self.topView.layoutIfNeeded()
            
        }) { _ in
            self.startView.alpha = 0.0
            
            self.isQuizStarted = true
            self.visibleCellButtonsEnabled(true)
            self.togglePlay()
        }
    }
}

extension QuizPhoneVC {
    
    // MARK: - UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: collectionInsets * 3,
                            left: collectionInsets + collectionLineSpacing,
                            bottom: collectionInsets + collectionLineSpacing,
                            right: collectionInsets + collectionLineSpacing)
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (view.frame.size.width - collectionLineSpacing * 2 - (collectionInsets * 2 - 6)), height: QuestionCell.cellHeight)
    }
}
