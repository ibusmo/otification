//
//  AppDelegate.swift
//  oishi
//
//  Created by warinporn khantithamaporn on 8/10/2559 BE.
//  Copyright © 2559 com.rollingneko. All rights reserved.
//

import UIKit
import AudioToolbox
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        application.setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.None)
        
        let notificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
        
        if ((UIScreen.mainScreen().bounds.size.height / UIScreen.mainScreen().bounds.size.width) < 1.5) {
            self.window = UIWindow(frame: CGRectMake(115.0, 32.0, 540.0, 960.0))
            let bg = UIImageView(frame: CGRectMake(-115.0, -32.0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height))
            bg.image = UIImage(named: "ipad_bg")
            
            /*
            let dummy = DummyViewController()
            dummy.view.frame = CGRectMake(0.0, 0.0, 540, 960.0)
            dummy.view.backgroundColor = UIColor.redColor()
            self.window?.rootViewController = dummy
            self.window?.makeKeyAndVisible()
             */
            
            self.window?.addSubview(bg)
            self.window?.sendSubviewToBack(bg)
        } else {
            self.window = UIWindow(frame: CGRectMake(0.0, 0.0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height))
        }
        
        AlarmManager.sharedInstance.getAlarmListToObjects()
        AlarmManager.sharedInstance.removeAllAlarm()
        
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        
        /*
        for familyName in UIFont.familyNames() as [String] {
            print("\(familyName)\n")
            for fontName in UIFont.fontNamesForFamilyName(familyName) as [String] {
                print("\tFont: \(fontName)\n")
            }
        }
         */
        
        ViewControllerManager.sharedInstance.presentMyList()
        
//        if let options = launchOptions {
//            if let notification = options[UIApplicationLaunchOptionsLocalNotificationKey] as? UILocalNotification {
//                if let userInfo = notification.userInfo {
//                    let uid = userInfo["uid"] as! String
//                }
//            }
//        } else {
//            ViewControllerManager.sharedInstance.presentMyList()
//        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: - oishi
    
    // MARK: - notification
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        UIAlertView(title: "Alert !", message: "You didn't give our access for push notification.", delegate: self, cancelButtonTitle: "OK").show()
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        if let userInfo = notification.userInfo {
            let custom = userInfo["custom"] as! Bool
            if (custom) {
                let uid = userInfo["uid"] as! String
                ViewControllerManager.sharedInstance.presentVideoAlarm(uid + ".mov", uid: uid)
            } else {
                let uid = userInfo["uid"] as! String
                let fileName = userInfo["video"] as! String
                ViewControllerManager.sharedInstance.presentVideoAlarm(fileName, uid: uid)
            }
        }
    }

}

