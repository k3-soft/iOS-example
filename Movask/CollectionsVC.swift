//
//  CollectionsVC.swift
//  Movask
//
//  Created by Alina Yehorova on 03.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import UIKit

class CollectionsVC: UIViewController {
    
    // Labels
    @IBOutlet weak var appTitleLabel: UILabel!
    @IBOutlet weak var discoverLabel: UILabel!
    @IBOutlet weak var myLibraryLabel: UILabel!
    @IBOutlet weak var savedLabel: UILabel!
    
    // Collections
    @IBOutlet weak var discoverCollection: UICollectionView!
    @IBOutlet weak var libraryCollection: UICollectionView!
    @IBOutlet weak var savedCollection: UICollectionView!
    
    // Constraints
    @IBOutlet weak var heightDiscoverCollection: NSLayoutConstraint!
    
    // Data
    var discoverQuizes = [QuizTest]()
    var libraryQuizes = [QuizTest]()
    var savedQuizes = [QuizTest]()
    
    let cellReuseIdentifier = "QuizCell"
    
    var collectionLineSpacing: CGFloat {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return 10.0
        } else {
            return 20.0
        }
    }
    
    var collectionInsets: CGFloat {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return 20.0
        } else {
            return 40.0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setCollectionView()
        loadQuizes()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        // Reload collectin layout
        discoverCollection.collectionViewLayout.invalidateLayout()
        libraryCollection.collectionViewLayout.invalidateLayout()
        savedCollection.collectionViewLayout.invalidateLayout()
        
        
        // Reload visible cells content
        
        var cellsToReload = [UICollectionViewCell]()
        
        cellsToReload.append(contentsOf: discoverCollection.visibleCells)
        cellsToReload.append(contentsOf: savedCollection.visibleCells)
        
        for cell in cellsToReload {
            if let quizCell = cell as? QuizCell {
                quizCell.setWide(isLandscape: size.width > size.height, isInversed: false)
            }
        }
        
        for cell in libraryCollection.visibleCells {
            if let quizCell = cell as? QuizCell {
                quizCell.setWide(isLandscape: size.width > size.height, isInversed: true)
            }
        }
    }
    
    // MARK: - Views settings
    
    func setCollectionView() {
        
        let collections = [discoverCollection, libraryCollection, savedCollection]
        
        for collection in collections {
            collection?.register(UINib(nibName: cellReuseIdentifier, bundle: nil),
                                forCellWithReuseIdentifier: cellReuseIdentifier)
        }
    }
    
    // MARK: - Load data
    
    func loadQuizes() {
        
        discoverQuizes = Array(repeating: QuizTest(), count: 20)
        libraryQuizes = Array(repeating: QuizTest(), count: 20)
        savedQuizes = Array(repeating: QuizTest(), count: 20)
    }
    
    // MARK: - Actions
    
    func likeDidTap(cell: QuizCell) {
        print("Like tapped at \(cell.indexPath!)")
    }
    
    func qrDidTap(cell: QuizCell) {
        print("QR tapped at \(cell.indexPath!)")
    }
}

extension CollectionsVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == discoverCollection {
            return discoverQuizes.count
            
        } else if collectionView == libraryCollection {
            return libraryQuizes.count
            
        } else if collectionView == savedCollection {
            return savedQuizes.count
            
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! QuizCell

        cell.indexPath = indexPath
        
        if collectionView == discoverCollection {
            cell.setWithQuiz(discoverQuizes[indexPath.row], isInversed: false)
            
        } else if collectionView == libraryCollection {
            cell.setWithQuiz(libraryQuizes[indexPath.row], isInversed: true)
            
        } else if collectionView == savedCollection {
            cell.setWithQuiz(savedQuizes[indexPath.row], isInversed: false)
        }
        
        cell.likeHandler = { [unowned self] (container) in
            self.likeDidTap(cell: container)
        }
        
        cell.qrHandler = { [unowned self] (container) in
            self.qrDidTap(cell: container)
        }
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: collectionInsets / 2, left: collectionInsets, bottom: collectionInsets / 2, right: collectionInsets)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let normalSize = CGSize(width: (view.frame.size.width - collectionLineSpacing - collectionInsets * 2) / 2.2, height: QuizCell.cellHeight)
        let smallSize = CGSize(width: (view.frame.size.width - collectionLineSpacing - collectionInsets * 2) / 4, height: QuizCell.cellHeight)
        let wideSize = CGSize(width: (view.frame.size.width - collectionLineSpacing - collectionInsets * 2) / 4 * 2.5, height: QuizCell.cellHeight)
        
        if UIApplication.shared.isLandscape {
            if collectionView == libraryCollection {
                return indexPath.row % 2 == 0 ? wideSize : smallSize
            } else {
                return indexPath.row % 2 == 0 ? smallSize : wideSize
            }
        } else {
            return normalSize
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return collectionLineSpacing
    }
}
