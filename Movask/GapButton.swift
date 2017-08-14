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
    
    var wordIsMissing: Bool = false {
        willSet {
            switch newValue {
            case true:
                self.setTitle("-", for: .normal)
                self.titleLabel!.clipsToBounds = false
            case false:
                self.setTitle("+", for: .normal)
                self.titleLabel!.clipsToBounds = false
            }
        }
    }
    
    convenience init(frame: CGRect, gapWord: String, wordIndex: Int, wordRange: NSRange, wordIsMissing: Bool) {
        self.init(frame: frame)
        
        self.gapWord = gapWord
        self.wordIndex = wordIndex
        self.wordRange = wordRange
        self.setWordMissingStatus(status: wordIsMissing)
        
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        self.titleLabel?.textColor = UIColor.white
    }
    
    override private init(frame: CGRect) {
        self.gapWord = ""
        self.wordIndex = 0
        self.wordRange = NSRange()
        self.wordIsMissing = false
        
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setWordMissingStatus(status: Bool) {
        self.wordIsMissing = status
    }
    
    
}
