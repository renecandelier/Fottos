//
//  AppDelegate.swift
//  Fottos
//
//  Created by Rene Candelier on 12/19/18.
//  Copyright © 2018 Novus Mobile. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        fetchConfig()
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        Store.shareInstance?.saveContext()
    }
}

extension AppDelegate {
    func fetchConfig() {
        FectConfigFeed().fetchConfig { (json, error) in
            asyncMain {
                self.showHomeTabBarStoryboard()
            }
        }
    }
    
    func showHomeTabBarStoryboard() {
        guard let controller = UIStoryboard(name: "HomeTabBar", bundle: nil).instantiateInitialViewController() else { return }
        window?.rootViewController = controller
    }
}

