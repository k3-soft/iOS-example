//
//  QuizResultsPadVC.swift
//  Movask
//
//  Created by Alina Yehorova on 15.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import UIKit

class QuizResultsPadVC: QuizResultsVC {
    
    // Navigation bar
    @IBOutlet weak var rewardLabel: UILabel!
    @IBOutlet weak var savedLabel: UILabel!
    
    // Collection settings
    
    override var collectionLineSpacing: CGFloat {
        return 40.0
    }
    override var collectionInsets: CGFloat {
        return 60.0
    }
    
    // MARK: - VC lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    deinit {
        print("QuizResultsPadVC was deallocated")
    }
    
    // MARK: - Set views
    
    override func setNavigationBar() {
        super.setNavigationBar()
    }
    
    override func setResults() {
        super.setResults()
        
        let correctAnswers = getCorrectAnswersCount()
        let questionsCount = questionsList.count
        
        rewardLabel.text = "\(correctAnswers)/\(questionsCount)"
    }
}

extension QuizResultsPadVC {
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: collectionInsets / 3,
                            left: collectionInsets + collectionLineSpacing * 1.5,
                            bottom: collectionInsets,
                            right: collectionInsets + collectionLineSpacing * 1.5)
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (view.frame.size.width - collectionLineSpacing * 2 - (collectionInsets * 3)), height: ResultQuestionCell.cellHeight)
    }
}
