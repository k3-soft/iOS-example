//
//  LibraryVC.swift
//  Movask
//
//  Created by Alina Yehorova on 02.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import UIKit

class LibraryVC: BasicVC {

    @IBOutlet weak var userQuizesTitle: UILabel!
    @IBOutlet weak var userQuizesCollectionView: UICollectionView!
    
    var userQuizes = [QuizTest]()
    
    let cellReuseIdentifier = "QuizCell"
    let collectionLineSpacing: CGFloat = 10.0
    let collectionInsets: CGFloat = 20.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCollectionView()
        loadUserQuizes()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        // Reload collectin layout
        userQuizesCollectionView.collectionViewLayout.invalidateLayout()
        
        // Reload visible cells content
        for cell in userQuizesCollectionView.visibleCells {
            if let quizCell = cell as? QuizCell {
                quizCell.setWide()
            }
        }
    }
    
    // MARK: - Views settings
    
    func setCollectionView() {
        
        userQuizesCollectionView.register(UINib(nibName: cellReuseIdentifier, bundle: nil),
                                          forCellWithReuseIdentifier: cellReuseIdentifier)
    }
    
    // MARK: - Load data
    
    func loadUserQuizes() {
        
        userQuizes = Array(repeating: QuizTest(), count: 20)
    }
}

extension LibraryVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return userQuizes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! QuizCell
        
        cell.indexPath = indexPath
        cell.setWithQuiz(userQuizes[indexPath.row])
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: collectionInsets / 2, left: collectionInsets, bottom: collectionInsets, right: collectionInsets)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let normalSize = CGSize(width: (view.frame.size.width - collectionLineSpacing - collectionInsets * 2) / 2, height: QuizCell.cellHeight)
        let smallSize = CGSize(width: (view.frame.size.width - collectionLineSpacing - collectionInsets * 2) / 3, height: QuizCell.cellHeight)
        let wideSize = CGSize(width: (view.frame.size.width - collectionLineSpacing - collectionInsets * 2) / 3 * 2, height: QuizCell.cellHeight)
        
        if UIDevice.current.orientation.isLandscape {
            
            if indexPath.row % 2 == 0 {
                return (indexPath.row / 2) % 2 == 0 ? smallSize : wideSize
            } else {
                return (indexPath.row / 2) % 2 == 0 ? wideSize : smallSize
            }
            
        } else {
            return normalSize
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return collectionLineSpacing
    }
}

