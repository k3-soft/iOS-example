//
//  QuizPadVC.swift
//  Movask
//
//  Created by Alina Yehorova on 11.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import UIKit

class QuizPadVC: QuizVC {
    
    // Video view
    
    override var replayButtonFrame: CGRect {
        return CGRect(x: startButton.frame.midX - (145.0 / 2), y: startButton.frame.maxY + 5.0, width: 145.0, height: 40.0)
    }
    
    // Start
    
    @IBOutlet weak var topStartButton: NSLayoutConstraint!
    
    // Collection settings
    
    override var collectionLineSpacing: CGFloat {
        return 40.0
    }
    override var collectionInsets: CGFloat {
        return 60.0
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
            
            self.videoPlayer?.unhideControls()
            
            self.replayButton?.removeFromSuperview()
            self.replayButton = nil
            
            self.togglePlay()
        }
    }
    
    override func hideMovie() {
        super.hideMovie()
        
        guard isMovieOpen else { return }
        
        videoPlayer?.hideControlsTotally()
        
        isMovieOpen = false
        
        initiateReplayButton()
        UIView.animate(withDuration: 0.3, animations: {
            self.replayButton?.center.y += 50.0
            self.replayButton?.alpha = 1.0
        })
    }
    
    // MARK: - Actions
    
    @IBAction override func startMovie(_ sender: UIButton) {
        super.startMovie(sender)
        
        topStartButton.constant -= startButton.frame.height
        
        UIView.animate(withDuration: 0.3, animations: {
            self.topView.layoutIfNeeded()
            self.startButton.alpha = 0.0
        }) { _ in
        
            self.isQuizStarted = true
            self.visibleCellButtonsEnabled(true)
            self.videoPlayer.unhideControls()
            self.togglePlay()
        }
    }
}

extension QuizPadVC {
    
    // MARK: - UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: collectionInsets * 1.5 - 10.0,
                            left: collectionInsets + collectionLineSpacing * 1.5,
                            bottom: collectionInsets,
                            right: collectionInsets + collectionLineSpacing * 1.5)
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (view.frame.size.width - collectionLineSpacing * 2 - (collectionInsets * 3)), height: QuestionCell.cellHeight)
    }
}


