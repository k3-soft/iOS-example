//
//  AppDelegate.swift
//  Movask
//
//  Created by Alina Yehorova on 01.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        AuthorizationManager.setToken()
        
        setInitialViewController()
        setFabric()
        setKeyboardManager()
        
        return true
    }
    
    func setInitialViewController() {
        
        let vc = AuthorizationVC()
        //let vc = CollectionsVC()
        //let vc = QuizPadVC()
        //let vc = QuizPhoneVC()
        
        let navigationVC = UINavigationController(rootViewController: vc)
        navigationVC.setNavigationBarHidden(true, animated: false)
        
        UINavigationBar.appearance().barTintColor = UIColor.white
        UINavigationBar.appearance().tintColor = BrandColor.darkGreen
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.black]
        
        window?.rootViewController = navigationVC
        window?.makeKeyAndVisible()

    }

    func applicationWillResignActive(_ application: UIApplication) { }

    func applicationDidEnterBackground(_ application: UIApplication) { }

    func applicationWillEnterForeground(_ application: UIApplication) { }

    func applicationDidBecomeActive(_ application: UIApplication) { }

    func applicationWillTerminate(_ application: UIApplication) { }

    // MARK: - Initial settings 3d-party libraries
    
    func setFabric() {
        Fabric.with([Crashlytics.self])
        Fabric.sharedSDK().debug = true
    }
    
    func setKeyboardManager() {
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
    }
}

