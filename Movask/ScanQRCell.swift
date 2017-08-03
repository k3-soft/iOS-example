//
//  ScanQRCell.swift
//  Movask
//
//  Created by Alina Yehorova on 04.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import UIKit

class ScanQRCell: UICollectionViewCell {

    @IBOutlet weak var scanButton: UIButton!
    
    var scanHandler: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        scanButton.titleLabel?.textAlignment = .center
    }
    
    @IBAction func scanDidTap(_ sender: UIButton) {
        scanHandler?()
    }
}
