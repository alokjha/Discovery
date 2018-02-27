//
//  AppDelegate.swift
//  Discovery
//
//  Created by Alok Jha on 22/02/18.
//  Copyright © 2018 Alok Jha. All rights reserved.
//

import UIKit
import AsyncDisplayKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.white
        self.window?.rootViewController = configureTabBar()
        self.window?.makeKeyAndVisible()
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.white
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.white]
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = NSAttributedString(string: "Search...", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])

        return true
    }
    
    func configureTabBar() -> UITabBarController {
        
    
        let unselected_textColor = UIColor(white: 49/255.0, alpha: 1.0)
        
        let selected_textColor = UIColor(red: 221/255.0, green: 87/255.0, blue: 0, alpha: 1.0)
        
        let unselected_attributes = [NSAttributedStringKey.foregroundColor : unselected_textColor , NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15.0)]
        
        let selected_attributes = [NSAttributedStringKey.foregroundColor : selected_textColor , NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15.0)]
        
        let profileVC = UINavigationController(rootViewController: ASViewController())
        profileVC.tabBarItem.title = "Profile"
        profileVC.tabBarItem.isEnabled = false
        profileVC.tabBarItem.setTitleTextAttributes(unselected_attributes, for: UIControlState.normal)
        profileVC.tabBarItem.setTitleTextAttributes(selected_attributes, for: UIControlState.selected)
        
        let shoutOutVC = UINavigationController(rootViewController: ASViewController())
        shoutOutVC.tabBarItem.title = "ShoutOut"
        shoutOutVC.tabBarItem.isEnabled = false
        shoutOutVC.tabBarItem.setTitleTextAttributes(unselected_attributes, for: UIControlState.normal)
        shoutOutVC.tabBarItem.setTitleTextAttributes(selected_attributes, for: UIControlState.selected)
        
        let discoveryVC = UINavigationController(rootViewController: DiscoveryViewController())
        discoveryVC.tabBarItem.title = "Discovery"
        discoveryVC.tabBarItem.setTitleTextAttributes(unselected_attributes, for: UIControlState.normal)
        discoveryVC.tabBarItem.setTitleTextAttributes(selected_attributes, for: UIControlState.selected)
        
        let chatsVC = UINavigationController(rootViewController: ASViewController())
        chatsVC.tabBarItem.title = "Chats"
        chatsVC.tabBarItem.isEnabled = false
        chatsVC.tabBarItem.setTitleTextAttributes(unselected_attributes, for: UIControlState.normal)
        chatsVC.tabBarItem.setTitleTextAttributes(selected_attributes, for: UIControlState.selected)
        
        let journeyVC = UINavigationController(rootViewController: ASViewController())
        journeyVC.tabBarItem.title = "Journey"
        journeyVC.tabBarItem.isEnabled = false
        journeyVC.tabBarItem.setTitleTextAttributes(unselected_attributes, for: UIControlState.normal)
        journeyVC.tabBarItem.setTitleTextAttributes(selected_attributes, for: UIControlState.selected)
        
        let tabVC = UITabBarController()
        tabVC.viewControllers = [profileVC,shoutOutVC,discoveryVC,chatsVC,journeyVC]
        tabVC.selectedIndex = 2
        tabVC.tabBar.isTranslucent = false
        tabVC.tabBar.barTintColor = UIColor.white
        
        return tabVC
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

