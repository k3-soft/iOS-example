//
//  UIView+Controller.swift
//  Movask
//
//  Created by Alina Yehorova on 30.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import UIKit

extension UIView {
    
    public func viewController() -> UIViewController? {
        
        var nextResponder: UIResponder? = self
        
        repeat {
            
            nextResponder = nextResponder?.next
            
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
            
        } while nextResponder != nil
        
        return nil
    }
}
