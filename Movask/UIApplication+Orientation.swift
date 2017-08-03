//
//  UIApplication+Orientation.swift
//  Movask
//
//  Created by Alina Yehorova on 03.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import UIKit

extension UIApplication {
    
    var isLandscape: Bool {
 
        switch statusBarOrientation {
        case .landscapeLeft, .landscapeRight:
            return true
        default:
            return false
        }
    }
}
