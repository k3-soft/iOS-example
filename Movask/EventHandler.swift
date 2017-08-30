//
//  EventHandler.swift
//  Movask
//
//  Created by Alina Yehorova on 02.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import UIKit

enum ErrorType {
    
    case serverError
    case authorizationError
    
    var title: String {
        
        switch self {
        case .serverError:
            return "Server error"
        case .authorizationError:
            return "Authorization error"
        }
    }
}

protocol EventHandler {
    
}

extension EventHandler {
    
    func showAlertWith(error: ErrorType, controller: UIViewController?) {
        showAlertWith(text: error.title, controller: controller)
    }
    
    func showAlertWith(text: String, controller: UIViewController?) {
        
        let alertVC = UIAlertController(title: nil, message: text, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertVC.addAction(okAction)
        
        controller?.present(alertVC, animated: true, completion: nil)
    }
}
