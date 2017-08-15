//
//  QuestionCellInterface.swift
//  Movask
//
//  Created by Alina Yehorova on 10.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import UIKit

protocol QuestionCellHandler {
    
    weak var confirmButton: UIButton! { get set }
    weak var skipButton: UIButton! { get set }
    
    var confirmHandler: (()->())? { get set }
    var skipHandler: (()->())? { get set }
}

extension QuestionCellHandler {
    
    func buttonsEnabled(_ enabled: Bool) {
        
        confirmButton.backgroundColor = enabled ? BrandColor.green : UIColor.white
        confirmButton.setTitleColor(enabled ? UIColor.white : BrandColor.lightGray, for: .normal)
        confirmButton.isEnabled = enabled
        
        skipButton.backgroundColor = enabled ? BrandColor.lightGray : UIColor.white
        skipButton.setTitleColor(enabled ? BrandColor.gray : BrandColor.lightGray, for: .normal)
        skipButton.isEnabled = enabled
    }
}
