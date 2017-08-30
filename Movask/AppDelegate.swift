//
//  AppDelegate.swift
//  Movask
//
//  Created by Alina Yehorova on 01.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        AuthorizationManager.setToken()
        
        setInitialViewController()
        
        return true
    }
    
    func setInitialViewController() {
        
        let vc = CollectionsVC()
        
        let navigationVC = UINavigationController(rootViewController: vc)
        navigationVC.setNavigationBarHidden(true, animated: false)
        
        window?.tintColor = BrandColor.green
        
        window?.rootViewController = navigationVC
        window?.makeKeyAndVisible()

    }

    func applicationWillResignActive(_ application: UIApplication) { }

    func applicationDidEnterBackground(_ application: UIApplication) { }

    func applicationWillEnterForeground(_ application: UIApplication) { }

    func applicationDidBecomeActive(_ application: UIApplication) { }

    func applicationWillTerminate(_ application: UIApplication) { }
}

