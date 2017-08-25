//
//  UIView+Animations.swift
//  Movask
//
//  Created by Alina Yehorova on 25.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import UIKit

extension UIView {
    
    func animatePush(completion: ((Bool)->())?) {
        
        UIView.animate(withDuration: 0.1, animations: {
            self.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5.0, options: .curveEaseOut, animations: {
                self.transform = CGAffineTransform.identity
            }, completion: completion)
        }
    }
}
