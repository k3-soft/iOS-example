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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var isUserRegistered = false

    override func viewDidLoad() {
        super.viewDidLoad()

        setLocalization()
        loadProfile()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        okButton.layer.cornerRadius = okButton.bounds.height / 2
    }
    
    // MARK: - Set views
    
    func setLocalization() {
        okButton.setTitle("OK", for: .normal)
        nicknameField.placeholder = "Enter nickname"
    }
    
    func updateNicknameField(text: String, isEnabled: Bool) {
        
        nicknameField.text = text
        nicknameField.isEnabled = isEnabled
        
        okButton.isEnabled = isEnabled
    }
    
    func setRegistrationState(isRegistered: Bool, profile: Profile? = nil) {
        
        activityIndicator.stopAnimating()
        
        if isRegistered {
            updateNicknameField(text: profile?.username ?? "", isEnabled: true)
            isUserRegistered = true
            
        } else {
            updateNicknameField(text: "", isEnabled: true)
            isUserRegistered = false
        }
    }
    
    func showServerError() {
        stopLoading()
        showAlertWith(text: "Server error", controller: self)
    }
    
    // MARK: - Load data
    
    func loadProfile() {
        
        activityIndicator.startAnimating()
        updateNicknameField(text: "Loading...", isEnabled: false)
        
        APIManager().getCurrentUser(success: { [weak self] (response) in
            print(response)
            
            if let profile = AuthorizationManager.updateProfile(with: response) {
                self?.setRegistrationState(isRegistered: true, profile: profile)
            } else {
                self?.setRegistrationState(isRegistered: true)
            }
            
        }) { [weak self] (error) in
            print("Error loading profile:" + error.localizedDescription)
            self?.setRegistrationState(isRegistered: false)
        }
    }
    
    // MARK: - Actions

    @IBAction func okDidTap(_ sender: UIButton) {
        sender.animatePush { [unowned self] _ in
            self.checkProfile()
        }
    }
    
    func checkProfile() {
        
        guard let nickname = nicknameField.text, !nickname.isEmpty else { return }
        
        startLoading()
        
        if isUserRegistered {
            
            // Update profile nickname
            
            let profile = Profile()
            profile.username = nickname
            
            let profileForm = ProfileEditForm(profileForm: profile)
            
            APIManager().updateUserProfile(data: profileForm, success: { [weak self] (response) in
                print("Profile was updated")
                
                AuthorizationManager.updateProfile(with: response)
                self?.showCollections()
                
            }, failure: { [weak self] (error) in
                print("Error loading profile:" + error.localizedDescription)
                self?.showServerError()
            })
            
        } else {
            
            // Register user
            
            let profile = Profile()
            profile.username = nickname
            profile.deviceID = AuthorizationManager.token
            
            let profileForm = ProfileRegistrationForm(profileForm: profile)
            
            APIManager().registerUserProfile(data: profileForm, success: { [weak self] (response) in
                print("User was registered")
                
                AuthorizationManager.updateProfile(with: response)
                self?.showCollections()
                
                }, failure: { [weak self] (error) in
                    print("Error registration user:" + error.localizedDescription)
                    self?.showServerError()
            })
        }
    }
    
    func showCollections() {
        
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
