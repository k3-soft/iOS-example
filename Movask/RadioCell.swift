//
//  RadioCell.swift
//  Movask
//
//  Created by mac on 08.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import UIKit

class RadioCell: UITableViewCell {
    
    @IBOutlet weak var radioImage: UIImageView!
    @IBOutlet weak var radioTextView: UnderLinedTextView!
    
    var selectedCell = false {
        didSet {
            if selectedCell {
                radioTextView.textColor = UIColor(colorWithHexValue: 0x417505)
                radioImage.backgroundColor = UIColor.green
            } else {
                radioTextView.textColor = UIColor(colorWithHexValue: 0x808080)
                radioImage.backgroundColor = UIColor.red
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        radioTextView.textContainer.maximumNumberOfLines = 1
    }
}

