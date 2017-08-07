//
//  CreateQuizVC.swift
//  Movask
//
//  Created by mac on 07.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import UIKit

class CreateQuizVC: BasicVC {
    
    @IBOutlet weak var quizCollectionView: UICollectionView!
    
    let headerCell = "QuizHeaderCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupCollectionView()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        quizCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    func setupNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.isTranslucent = false
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveTapped))
        navigationItem.title = "Quiz Maker"
    }
    
    func setupCollectionView() {
        quizCollectionView.delegate = self
        quizCollectionView.dataSource = self
        let flow = quizCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flow.sectionHeadersPinToVisibleBounds = true
        
        quizCollectionView.register(UINib(nibName: headerCell, bundle: nil),
                                     forCellWithReuseIdentifier: headerCell)
        quizCollectionView.register(UINib(nibName: headerCell, bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerCell)

    }
    
    //MARK:- ACTIONS
    
    func saveTapped() {
        print("save tapped")
    }
    
    

    
}




extension CreateQuizVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
            
        case UICollectionElementKindSectionHeader:
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerCell, for: indexPath) as! QuizHeaderCell
            headerView.backgroundColor = UIColor.black
            return headerView
            
        default:
            assert(false, "Unexpected element kind")
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: headerCell, for: indexPath) as! QuizHeaderCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIApplication.shared.isLandscape {
            return CGSize(width: self.view.frame.width, height: self.view.frame.height / 2)
        }
        return CGSize(width: self.view.frame.width, height: self.view.frame.height / 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if UIApplication.shared.isLandscape {
            return CGSize(width: self.view.frame.width, height: self.view.frame.height / 2)
        }
        return CGSize(width: self.view.frame.width, height: self.view.frame.height / 3)
    }
}
