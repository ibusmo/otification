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
import SwiftKeychainWrapper
import FBSDKCoreKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        application.setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.None)
        
        let notificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        application.registerUserNotificationSettings(notificationSettings)
        application.registerForRemoteNotifications()
        
        if ((UIScreen.mainScreen().bounds.size.height / UIScreen.mainScreen().bounds.size.width) < 1.5) {
            self.window = UIWindow(frame: CGRectMake(114.0, 32.0, 540.0, 960.0))
            
            let bg = UIImageView(frame: CGRectMake(-114.0, -32.0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height))
            bg.image = UIImage(named: "ipad_bg")
            bg.backgroundColor = UIColor.blackColor()
            
            self.window?.addSubview(bg)
            self.window?.sendSubviewToBack(bg)
        } else {
            self.window = UIWindow(frame: CGRectMake(0.0, 0.0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height))
        }
        
        AlarmManager.sharedInstance.getAlarmListToObjects()
        AlarmManager.sharedInstance.getFriendAlarmListToObjects()
        
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        
        ViewControllerManager.sharedInstance.presentIndex()
        
        // MARK: - facebook
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // MARK: - appsflyer
        
        AppsFlyerTracker.sharedTracker().appsFlyerDevKey = "HGETasn6yh8FhMC2LQgEWP"
        AppsFlyerTracker.sharedTracker().appleAppID = "965172855"
        
        // MARK: - parse
        
        Parse.setApplicationId("hcQPULoCz11pZmdmxDP5ZiDciS3ZmP5nXdcxjQzG", clientKey: "ZkIBK8C8AY0UAv6DbPtNupqfYbUoajEHh7maLRsN")
        
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
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let installation = PFInstallation.currentInstallation()
        installation!.setDeviceTokenFromData(deviceToken)
        installation!.saveInBackground()
    }
    
    // MARK: - oishi
    
    // MARK: - notification
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        if let userInfo = notification.userInfo {
            let custom = userInfo["custom"] as! Bool
            let uid = userInfo["uid"] as! String
            if (custom) {
                ViewControllerManager.sharedInstance.presentVideoAlarm(uid + ".mov", uid: uid)
            } else {
                let fileName = userInfo["video"] as! String
                ViewControllerManager.sharedInstance.presentVideoAlarm(fileName, uid: uid)
            }
            UIApplication.sharedApplication().cancelLocalNotification(notification)
        }
    }

}

