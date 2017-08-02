//
//  QuizCell.swift
//  Movask
//
//  Created by Alina Yehorova on 02.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import UIKit

class QuizCell: UICollectionViewCell {
    
    // Labels
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var viewsLabel: UILabel!
    
    // Cover
    @IBOutlet weak var coverContainer: UIView!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var coverBlackView: UIView!
    @IBOutlet weak var coverBottomConstraint: NSLayoutConstraint!
    
    // Constants
    var coverBottomConstantDefault: CGFloat {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return 85.0
        } else {
            return 120.0
        }
    }
    static var cellHeight: CGFloat {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return 280.0
        } else {
            return 400.0
        }
    }
    
    // Data
    var quiz: QuizTest?
    var indexPath: IndexPath?
    
    // Customization
    var isWideSize = false {
        didSet {
            categoryLabel.textColor = isWideSize ? UIColor.white : UIColor.gray
            titleLabel.textColor = isWideSize ? UIColor.white : UIColor.darkGray
            ownerLabel.textColor = isWideSize ? UIColor.gray : UIColor.orange
            
            UIView.animate(withDuration: 0.3) { 
                self.coverBottomConstraint.constant = self.isWideSize ? 0.0 : self.coverBottomConstantDefault
                self.coverBlackView.alpha = self.isWideSize ? 0.25 : 0.0
                self.layoutIfNeeded()
            }
        }
    }

    override func prepareForReuse() {
        coverImageView.image = nil
    }
    
    func setWithQuiz(_ currentQuiz: QuizTest) {
        
        quiz = currentQuiz
        
        setWide()
        
        // Set labels
        
        categoryLabel.text = currentQuiz.category
        titleLabel.text = currentQuiz.title
        ownerLabel.text = currentQuiz.owner
        viewsLabel.text = "\(currentQuiz.viewsCount)"
        
        // Set cover
        
        CacheManager().setImageFor(imageView: coverImageView, path: currentQuiz.imagePath, imageID: currentQuiz.id)
    }
    
    func setWide() {
        
        guard indexPath != nil else { return }
        
        if UIDevice.current.orientation.isLandscape {
            if indexPath!.row % 2 == 0 {
                isWideSize = (indexPath!.row / 2) % 2 != 0
            } else {
                isWideSize = (indexPath!.row / 2) % 2 == 0
            }
            
        } else {
            isWideSize = false
        }
    }
}
