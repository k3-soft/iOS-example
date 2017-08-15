//
//  QuizResultsPhoneVC.swift
//  Movask
//
//  Created by Alina Yehorova on 14.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import UIKit

class QuizResultsPhoneVC: QuizResultsVC {
    
    // Collection settings
    
    override var collectionLineSpacing: CGFloat {
        return 10.0
    }
    override var collectionInsets: CGFloat {
        return 15.0
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
        print("QuizResultsPhoneVC was deallocated")
    }
}

extension QuizResultsPhoneVC {
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: collectionInsets,
                            left: collectionInsets + collectionLineSpacing,
                            bottom: collectionInsets + collectionLineSpacing,
                            right: collectionInsets + collectionLineSpacing)
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (view.frame.size.width - collectionLineSpacing * 2 - (collectionInsets * 2 - 6)), height: ResultQuestionCell.cellHeight)
    }
}
