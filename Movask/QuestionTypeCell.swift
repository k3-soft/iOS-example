//
//  QuestionTypeCell.swift
//  Movask
//
//  Created by mac on 28.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import UIKit

class QuestionTypeCell: UICollectionViewCell {
    
    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!
    
    var selectedCell = false {
        didSet {
            if selectedCell {
                checkImageView.image = UIImage(named: "CheckGray")
            } else {
                checkImageView.image = nil
            }
        }
    }
    
}
