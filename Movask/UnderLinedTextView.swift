//
//  UnderlinedTextView.swift
//  Movask
//
//  Created by mac on 07.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import UIKit
import KMPlaceholderTextView

class UnderLinedTextView: KMPlaceholderTextView {
    
    var line: UIView = {
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = UIColor(colorWithHexValue: 0xE7E7E7)
        return line
    }()
    
    var lineTopConstraint = NSLayoutConstraint()
    var lineHeightConstraint = NSLayoutConstraint()
    var lineCenterConstraint = NSLayoutConstraint()
    var lineLeadingConstraint = NSLayoutConstraint()
    var lineTrailingConstraint = NSLayoutConstraint()
    
    override public init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        self.textContainerInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
//        self.textContainer.lineFragmentPadding = 0
        self.returnKeyType = .done
        addSubview(line)
        addConstraints()
    }
    
    private func addConstraints() {
        lineTopConstraint = NSLayoutConstraint(item: line, attribute: .top, relatedBy: .equal,
                                               toItem: self, attribute: .top,
                                               multiplier: 1.0, constant: self.frame.height - 1)
        lineCenterConstraint = NSLayoutConstraint(item: line, attribute: .centerX, relatedBy: .equal,
                                                  toItem: self, attribute: .centerX,
                                                  multiplier: 1.0, constant: 0.0)
        lineLeadingConstraint = NSLayoutConstraint(item: line, attribute: .leading, relatedBy: .equal,
                                                   toItem: self, attribute: .leading,
                                                   multiplier: 1.0, constant: 0.0)
        lineTrailingConstraint = NSLayoutConstraint(item: line, attribute: .trailing, relatedBy: .equal,
                                                    toItem: self, attribute: .trailing,
                                                    multiplier: 1.0, constant: 0.0)
        lineHeightConstraint = NSLayoutConstraint(item: line, attribute: .height, relatedBy: .equal,
                                                  toItem: nil, attribute: .notAnAttribute,
                                                  multiplier: 1.0, constant: 1)
        
        self.addConstraints([lineCenterConstraint, lineTopConstraint, lineLeadingConstraint, lineTrailingConstraint, lineHeightConstraint])

    }
    
}
