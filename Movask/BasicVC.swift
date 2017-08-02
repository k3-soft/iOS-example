//
//  BasicVC.swift
//  Movask
//
//  Created by Alina Yehorova on 02.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import UIKit

class BasicVC: UIViewController, EventHandler {
    
    var loadingView: LoadingView?
    
    // MARK: - Initializers
    
    init() {
        super.init(nibName: String(describing: type(of: self)), bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Navigation
    
    func backDidTap() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Loading
    
    func startLoading() {
        
        if loadingView == nil {
            loadingView = .fromNib()
            loadingView!.frame = view.bounds
            view.addSubview(loadingView!)
        }
    }
    
    func stopLoading() {
        
        loadingView?.removeFromSuperview()
        loadingView = nil
    }
}
