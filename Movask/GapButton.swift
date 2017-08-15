//
//  GapButton.swift
//  Movask
//
//  Created by mac on 14.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import UIKit

class GapButton: UIButton {
    
    var gapWord: String
    var wordIndex: Int
    var wordRange: NSRange
    
    convenience init(frame: CGRect, gapWord: String, wordIndex: Int, wordRange: NSRange, wordIsMissing: Bool) {
        self.init(frame: frame)
        
        self.gapWord = gapWord
        self.wordIndex = wordIndex
        self.wordRange = wordRange
        self.isSelected = wordIsMissing
        
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        self.titleLabel?.textColor = UIColor.white
        self.setTitle("-", for: .selected)
        self.setTitle("+", for: .normal)
    }
    
    override private init(frame: CGRect) {
        self.gapWord = ""
        self.wordIndex = 0
        self.wordRange = NSRange()
        
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
