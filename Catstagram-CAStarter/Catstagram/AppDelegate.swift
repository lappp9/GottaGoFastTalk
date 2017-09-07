//
//  AppDelegate.swift
//  Catstagram-Starter
//
//  Created by Luke Parham on 2/9/17.
//  Copyright © 2017 Luke Parham. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = WindowWithStatusBar(frame: UIScreen.main.bounds)
        let rootNavController = UINavigationController(rootViewController: CatFeedViewController())
                
        let font = UIFont(name: "OleoScript-Regular", size: 20.0)!
        rootNavController.navigationBar.titleTextAttributes = [NSFontAttributeName: font]
        rootNavController.navigationBar.barTintColor = UIColor.white
        rootNavController.navigationBar.isOpaque = true
        rootNavController.navigationItem.titleView?.isOpaque = true
        rootNavController.navigationBar.isTranslucent = false
        window?.rootViewController = rootNavController
        window?.makeKeyAndVisible()
        
        return true
    }
}

