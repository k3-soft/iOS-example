//
//  MainVC.swift
//  Movask
//
//  Created by Alina Yehorova on 02.08.17.
//  Copyright © 2017 Alina Yehorova. All rights reserved.
//

import UIKit

class MainVC: BasicVC {
    
    var tabBarVC: UITabBarController?
    
    @IBOutlet weak var controllerContainer: UIView!
    @IBOutlet weak var lineSegmentedControl: LineSegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTabBarVC()
        setSegmentedControl()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        guard let tabBarControllers = tabBarVC?.viewControllers else { return }
        for vc in tabBarControllers {
            vc.viewWillTransition(to: size, with: coordinator)
        }
        
        lineSegmentedControl.updateLineStateWith(width: size.width)
    }
    
    // MARK: - Views settings
    
    func setTabBarVC() {
        
        tabBarVC = UITabBarController()
        
        tabBarVC!.viewControllers = [LibraryVC(), LevelsVC()]
        tabBarVC!.tabBar.isHidden = true
        
        addChildViewController(tabBarVC!)
        controllerContainer.addSubview(tabBarVC!.view)
        tabBarVC?.view.frame = controllerContainer.bounds
    }
    
    func setSegmentedControl() {
        
        lineSegmentedControl.createCell(title: "Library")
        lineSegmentedControl.createCell(title: "New & Trending")
        
        lineSegmentedControl.delegate = self
    }

}

extension MainVC: LineSegmentedControlDelegate {
    
    func lineSegmentedControl(_ control: LineSegmentedControl, didChangeSelection index: Int) {
        tabBarVC?.selectedIndex = index
    }
}


