//
//  AppDelegate.swift
//  LockScreenText
//
//  Created by Ben Staveley-Taylor on 06/11/2018.
//  Copyright © 2018 Ben Staveley-Taylor. All rights reserved.
//

import UIKit
import LockScreenTextFramework
import os.log

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        os_log("application didFinishLaunchingWithOptions")

        // All logic is in the framework
        self.window = UIWindow(frame: UIScreen.main.bounds)

        let bundle = Bundle(identifier: "com.staveleytaylor.ben.LockScreenTextFramework")
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        let initialVC = storyboard.instantiateInitialViewController()
        self.window?.rootViewController = initialVC
        self.window?.makeKeyAndVisible()

        Defaults.updateStorageLocation()

        // Appearance setup
        UITheme.setAppearanceDefaults()

        return true
    }

    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        // Detect "open settings" taps from the widget
        os_log("application open: %@", url.absoluteString)

        if let components = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            if components.scheme == LSConstants.navigationScheme {
                if let action = components.host {
                    DeepLinkHandler.shared.handleLink(action)
                }

                // As far as the os is concerned we always handled it.
                return true
            }
        }
        return false
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state.
        // This can occur for certain types of temporary interruptions (such as an
        // incoming phone call or SMS message) or when the user quits the application
        // and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate
        // graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers,
        // and store enough application state information to restore your application to
        // its current state in case it is terminated later.
        // If your application supports background execution, this method is called instea
        // of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here
        // you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was
        // inactive. If the application was previously in the background, optionally refresh
        // the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate.
        // See also applicationDidEnterBackground:.
    }

}
