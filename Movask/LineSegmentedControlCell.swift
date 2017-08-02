//
//  LineSegmentedControlCell.swift
//  Movask
//
//  Created by Alina Yehorova on 02.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import UIKit

class LineSegmentedControlCell: NibView {
    
    static let activeColor = UIColor.orange
    static let titleNonActiveColor = UIColor.gray

    @IBOutlet weak var titleLabel: UILabel!
    
    var title: String = "Title" {
        didSet {
            titleLabel?.text = title
        }
    }
    
    private(set) var isSelected = false
    var index: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel?.text = title
    }
    
    func setToSelectedState(_ state: Bool) {
        
        if state {
            titleLabel.textColor = LineSegmentedControlCell.activeColor
        } else {
            titleLabel.textColor = LineSegmentedControlCell.titleNonActiveColor
        }
        
        isSelected = state
    }
}
