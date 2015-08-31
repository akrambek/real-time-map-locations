//
//  AppDelegate.swift
//  TrackerFullMaptoolkit
//
//  Created by Norvan Sahiner on 01/14/15.
//  Copyright (c) 2014 Norvan Sahiner. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - Properties
    
	var window: UIWindow?
    
    // MARK: - App Life Cycle
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        // Adding a Navigation Controller and tool bar
        self.window!.rootViewController = UINavigationController(rootViewController: MainViewController(nibName: nil, bundle: nil))
        
        // Make window visible
        self.window!.makeKeyAndVisible()
        
        return true
    }
}
