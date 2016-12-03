//
//  AppDelegate.swift
//  SnappyChatty
//
//  Created by Anton Novoselov on 29/11/2016.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FIRApp.configure()
        
        customizeAppearance()
        
        let userNotificationTypes: UIUserNotificationType = [.badge]
        
        let notificationSettings = UIUserNotificationSettings(types: userNotificationTypes, categories: nil)
        
        application.registerUserNotificationSettings(notificationSettings)
        
        
        
        
        
        
        return true
    }
    
    func customizeAppearance() {
        let tintColor = UIColor(red: 255/255, green: 45/255, blue: 85/255, alpha: 1)
        window!.tintColor = tintColor
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
        
        
        let tabBarController = self.window?.rootViewController as! UITabBarController
//
        if let navigationController = tabBarController.viewControllers?.first as? UINavigationController {
            
            if let inboxViewController = navigationController.topViewController as? InboxViewController{
                
                let numberOfMessages = inboxViewController.messages.count
                
                UIApplication.shared.applicationIconBadgeNumber = numberOfMessages
            }
            
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        

        
    }


}

