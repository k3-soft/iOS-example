//
//  AnswerCheckboxCell.swift
//  Movask
//
//  Created by Alina Yehorova on 07.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import UIKit

class AnswerCheckboxCell: AnswerSelectionCell {
    
    override var checked: Bool {
        didSet {
            if checked {
                checkboxButton.setImage(UIImage(named: "CheckGray"), for: .normal)
            } else {
                checkboxButton.setImage(UIImage(named: "CheckEmptyGray"), for: .normal)
            }
        }
    }
}
