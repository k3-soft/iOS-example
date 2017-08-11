//
//  UILabel+Size.swift
//  Movask
//
//  Created by Alina Yehorova on 10.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import UIKit

extension UILabel {
    
    func boundingRectForCharacterRange(range: NSRange) -> CGRect? {
        
        guard let attributedText = attributedText else { return nil }
        
        let textStorage = NSTextStorage(attributedString: attributedText)
        let layoutManager = NSLayoutManager()
        
        textStorage.addLayoutManager(layoutManager)
        
        let textContainer = NSTextContainer(size: CGSize(width: bounds.size.width, height: CGFloat.greatestFiniteMagnitude))
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = lineBreakMode
        textContainer.maximumNumberOfLines = numberOfLines
        
        layoutManager.addTextContainer(textContainer)
        
        var glyphRange = NSRange()
        
        // Convert the range for glyphs.
        layoutManager.characterRange(forGlyphRange: range, actualGlyphRange: &glyphRange)
        print(glyphRange.length)
        print(glyphRange.location)
        
        return layoutManager.boundingRect(forGlyphRange: glyphRange, in: textContainer)
    }
}
