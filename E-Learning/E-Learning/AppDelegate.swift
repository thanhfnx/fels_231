//
//  AppDelegate.swift
//  E-Learning
//
//  Created by Thanh Nguyen on 2/8/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions
        launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // TODO: Remove this line in future
        UserDefaults.standard.removeObject(forKey: kLoggedInUserKey)
        let storyboardName: String
        if let userJSON = UserDefaults.standard.object(forKey: kLoggedInUserKey)
            as? [String: Any] {
            storyboardName = "Home"
            DataStore.shared.loggedInUser = User(keyedValues: userJSON)
        } else {
            storyboardName = "Main"
        }
        let homeStoryBoard = UIStoryboard(name: storyboardName, bundle: nil)
        let homeNavigationController = homeStoryBoard.instantiateInitialViewController()
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = homeNavigationController
        self.window?.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    
    }

    func applicationWillTerminate(_ application: UIApplication) {
    
    }

}

