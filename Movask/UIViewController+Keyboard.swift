//
//  UIViewController+Keyboard.swift
//  Movask
//
//  Created by Alina Yehorova on 11.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard(gestureReconizer:)))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard(gestureReconizer: UITapGestureRecognizer) {
        view.endEditing(true)
        view.removeGestureRecognizer(gestureReconizer)
    }
}
