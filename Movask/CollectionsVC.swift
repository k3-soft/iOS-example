//
//  CollectionsVC.swift
//  Movask
//
//  Created by Alina Yehorova on 03.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import UIKit

class CollectionsVC: BasicVC {
    
    // Labels
    @IBOutlet weak var appTitleLabel: UILabel!
    @IBOutlet weak var discoverLabel: UILabel!
    @IBOutlet weak var myLibraryLabel: UILabel!
    @IBOutlet weak var savedLabel: UILabel!
    
    // Buttons
    @IBOutlet weak var languageButton: UIButton!
    
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
    
    let quizCellIdentifier = "QuizCell"
    let addQuizCellIdentifier = "AddQuizCell"
    let scanQRCellIdentifier = "ScanQRCell"
    
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
    
    var cellScales: (normal: CGFloat, small: CGFloat, wide: CGFloat) {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return (2.1, 4, 1.75)
        } else {
            return (3.7, 5, 2.5)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setCollectionView()
        loadQuizes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
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
        
        // Special cells
        
        libraryCollection.register(UINib(nibName: addQuizCellIdentifier, bundle: nil),
                                   forCellWithReuseIdentifier: addQuizCellIdentifier)
        savedCollection.register(UINib(nibName: scanQRCellIdentifier, bundle: nil),
                                 forCellWithReuseIdentifier: scanQRCellIdentifier)
        
        // Quiz cells
        
        let collections = [discoverCollection, libraryCollection, savedCollection]
        
        for collection in collections {
            collection?.register(UINib(nibName: quizCellIdentifier, bundle: nil),
                                forCellWithReuseIdentifier: quizCellIdentifier)
        }
    }
    
    // MARK: - Load data
    
    func loadQuizes() {
        
        discoverQuizes = Array(repeating: QuizTest(), count: 20)
        libraryQuizes = Array(repeating: QuizTest(), count: 20)
        savedQuizes = Array(repeating: QuizTest(), count: 20)
    }
    
    // MARK: - Actions
    
    @IBAction func changeLanguage(_ sender: UIButton) {
        print("Change language")
    }
    
    func likeDidTap(cell: QuizCell) {
        print("Like tapped at \(cell.indexPath!)")
    }
    
    func qrDidTap(cell: QuizCell) {
        print("QR tapped at \(cell.indexPath!)")
    }
    
    func addNewQuiz() {
        print("Add new quiz")
        let createQuizVC = CreateQuizVC()
        navigationController?.pushViewController(createQuizVC, animated: true)
    }
    
    func scanQRCode() {
        print("Scan QR code")
    }
}

extension CollectionsVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == discoverCollection {
            return discoverQuizes.count
            
        } else if collectionView == libraryCollection {
            return libraryQuizes.count + 1
            
        } else if collectionView == savedCollection {
            return savedQuizes.count //+ 1
            
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Cell for adding quiz
        
        if collectionView == libraryCollection, indexPath.row == 0 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: addQuizCellIdentifier, for: indexPath) as! AddQuizCell
            
            cell.addHandler = { [unowned self] _ in
                self.addNewQuiz()
            }
            
            return cell
        }
        
        // Cell for scan QR code
        
        if collectionView == savedCollection, indexPath.row == 0 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: scanQRCellIdentifier, for: indexPath) as! ScanQRCell
            
            cell.scanHandler = { [unowned self] _ in
                self.scanQRCode()
            }
            
            return cell
        }
        
        // Quiz cells
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: quizCellIdentifier, for: indexPath) as! QuizCell

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
        
        var topScale = 0.5
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            topScale = 0.25
        }
        
        return UIEdgeInsets(top: collectionInsets * CGFloat(topScale),
                            left: collectionInsets,
                            bottom: collectionInsets * 0.5,
                            right: collectionInsets)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let normalSize = CGSize(width: (view.frame.size.width - collectionLineSpacing - collectionInsets * 2) / cellScales.normal, height: QuizCell.cellHeight)
        let smallSize = CGSize(width: (view.frame.size.width - collectionLineSpacing - collectionInsets * 2) / cellScales.small, height: QuizCell.cellHeight)
        let wideSize = CGSize(width: (view.frame.size.width - collectionLineSpacing - collectionInsets * 2) / cellScales.wide, height: QuizCell.cellHeight)
        
        // Special cells
        
        if (collectionView == libraryCollection || collectionView == savedCollection), indexPath.row == 0 {
            if UIApplication.shared.isLandscape {
                return smallSize
            } else {
                return normalSize
            }
        }
        
        // Quiz cells
        
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if (collectionView == libraryCollection || collectionView == savedCollection),
            indexPath.row == 0 { return }
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            let quizVC = QuizPhoneVC()
            navigationController?.pushViewController(quizVC, animated: true)
            
        } else {
            let quizVC = QuizPadVC()
            navigationController?.pushViewController(quizVC, animated: true)
        }
    }
}
