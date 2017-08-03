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
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    
    // Buttons
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var qrButton: UIButton!
    
    // Cover
    @IBOutlet weak var coverContainer: UIView!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var coverBlackView: UIView!
    
    // Constraints
    @IBOutlet weak var coverBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailingTitleLabel: NSLayoutConstraint!
    @IBOutlet weak var leadingTitleLabel: NSLayoutConstraint!
    
    // Action handlers
    var likeHandler: ((QuizCell)->())?
    var qrHandler: ((QuizCell)->())?
    
    // Constants
    var coverBottomConstantDefault: CGFloat {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return 80.0
        } else {
            return 105.0
        }
    }
    static var cellHeight: CGFloat {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return 245.0
        } else {
            return 400.0 // Need to change (heightCollectionView - 40)
        }
    }
    
    // Data
    var quiz: QuizTest?
    var indexPath: IndexPath?
    
    // Customization
    var isWideSize = false {
        didSet {
            DispatchQueue.main.async {
                self.descriptionLabel.textColor = self.isWideSize ? UIColor.white : UIColor.gray
                self.titleLabel.textColor = self.isWideSize ? UIColor.white : UIColor.darkGray
                
                self.coverBottomConstraint.constant = self.isWideSize ? 0.0 : self.coverBottomConstantDefault
                self.trailingTitleLabel.constant = self.isWideSize ? 10.0 : 0.0
                self.leadingTitleLabel.constant = self.isWideSize ? 10.0 : 0.0
            
                UIView.animate(withDuration: 0.2) {
                    self.layoutIfNeeded()
                    self.coverBlackView.alpha = self.isWideSize ? 0.25 : 0.0
                }
            }
        }
    }

    override func prepareForReuse() {
        coverImageView.image = UIImage(named: "EmptyImage")
    }
    
    func setWithQuiz(_ currentQuiz: QuizTest, isInversed: Bool) {
        
        quiz = currentQuiz
        
        setWide(isLandscape: UIApplication.shared.isLandscape, isInversed: isInversed)

        // Set labels
        
        titleLabel.text = currentQuiz.title
        descriptionLabel.text = currentQuiz.description
        likesLabel.text = "\(currentQuiz.likesCount)"
        
        // Set cover
        
        CacheManager().setImageFor(imageView: coverImageView, path: currentQuiz.imagePath, imageID: currentQuiz.id)
    }
    
    func setWide(isLandscape: Bool, isInversed: Bool) {
        
        guard indexPath != nil else { return }
        
        if isLandscape {
            if isInversed {
                isWideSize = indexPath!.row % 2 == 0
            } else {
                isWideSize = indexPath!.row % 2 != 0
            }
        } else {
            isWideSize = false
        }
    }
    
    // MARK: - Actions
    
    @IBAction func likeDidTap(_ sender: UIButton) {
        likeHandler?(self)
    }
    
    @IBAction func qrDidTap(_ sender: UIButton) {
        qrHandler?(self)
    }  
}
