//
//  NibView.swift
//  Movask
//
//  Created by Alina Yehorova on 30.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import UIKit

class NibView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        fromNib()
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fromNib()
        setupViews()
    }
    
    func setupViews() { }
}
