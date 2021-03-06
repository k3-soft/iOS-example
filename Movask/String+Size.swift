//
//  String+Size.swift
//  Movask
//
//  Created by Alina Yehorova on 03.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import UIKit

extension String {
    
    func textHeightWithFont(size: CGFloat, name: String, viewWidth: CGFloat, offset: CGFloat) -> CGFloat {
        
        let font = UIFont(name: name, size: size)
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .justified
        paragraph.lineBreakMode = .byWordWrapping
        
        let attributes: [String : Any] = [NSFontAttributeName: font as Any,
                                          NSParagraphStyleAttributeName: paragraph as Any]
        
        let rectSize = CGSize(width: viewWidth - 2 * offset, height: CGFloat.greatestFiniteMagnitude)
        
        let boundingRect = (self as NSString).boundingRect(with: rectSize, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: attributes, context: nil)
        
        return ceil(boundingRect.size.height + 2 * offset)
    }
}
