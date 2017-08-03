//
//  AddQuizCell.swift
//  Movask
//
//  Created by Alina Yehorova on 04.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import UIKit

class AddQuizCell: UICollectionViewCell {

    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!

    var addHandler: (()->())?
    
    @IBAction func addDidTap(_ sender: UIButton) {
        addHandler?()
    }
}
