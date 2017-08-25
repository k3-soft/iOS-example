//
//  AuthorizationVC.swift
//  Movask
//
//  Created by Alina Yehorova on 25.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import UIKit

class AuthorizationVC: BasicVC {
    
    @IBOutlet weak var nicknameField: UITextField!
    @IBOutlet weak var okButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        setLocalization()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        okButton.layer.cornerRadius = okButton.bounds.height / 2
    }
    
    // Set views
    
    func setLocalization() {
        
        okButton.setTitle("OK", for: .normal)
        nicknameField.placeholder = "Enter nickname"
    }
    
    // MARK: - Actions

    @IBAction func okDidTap(_ sender: UIButton) {
        sender.animatePush { [unowned self] _ in
            self.showCollections()
        }
    }
    
    func showCollections() {
        
        guard let nickaname = nicknameField.text, !nickaname.isEmpty else { return }
        
        let navigationVC = UINavigationController(rootViewController: CollectionsVC())
        UIApplication.shared.keyWindow?.set(toRootViewController: navigationVC)
    }
}

extension AuthorizationVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.isFirstResponder {
            textField.resignFirstResponder()
            okDidTap(okButton)
        }
        return true
    }
}
