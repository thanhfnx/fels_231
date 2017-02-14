//
//  AppDelegate.swift
//  E-Learning
//
//  Created by Thanh Nguyen on 2/8/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import UIKit
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func preProcessLogIn() {
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
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions
        launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.preProcessLogIn()
        FBSDKApplicationDelegate.sharedInstance().application(application,
            didFinishLaunchingWithOptions: launchOptions)
        return true
    }
    
    func application(_ app: UIApplication, open url: URL,
        options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(app,
            open: url, options: options)
    }

    func applicationWillResignActive(_ application: UIApplication) {
    
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(_ application: UIApplication) {
    
    }

}

