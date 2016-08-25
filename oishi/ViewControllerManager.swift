//
//  ViewControllerManager.swift
//  oishi
//
//  Created by warinporn khantithamaporn on 8/11/2559 BE.
//  Copyright © 2559 com.rollingneko. All rights reserved.
//

import Foundation
import UIKit

class ViewControllerManager {
    
    static let sharedInstance = ViewControllerManager()
    
    var myList: MyListTableViewController?
    var myListNav: UINavigationController?
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    private init() {}
    
    // MARK: - mylistableviewcontroller
    
    func getMyList() -> MyListTableViewController {
        if (self.myList == nil) {
            self.myList = MyListTableViewController(nibName: "MyListTableViewController", bundle: nil)
            self.myList?.showBottomBarView = true
            self.myList?.tabBar.setBottomBarView("เตือนตัวเอง", rightButtonTitle: "ส่งให้เพื่อน", leftButtonSelected: true)
        }
        return self.myList!
    }
    
    func getMyListNav() -> UINavigationController {
        if (self.myListNav == nil) {
            self.myListNav = UINavigationController(rootViewController: self.getMyList())
            self.myListNav?.setNavigationBarHidden(true, animated: false)
        }
        return self.myListNav!
    }
    
    func presentMyList() {
        self.appDelegate.window?.rootViewController = self.getMyList()
        self.appDelegate.window?.makeKeyAndVisible()
    }
    
    // MARK: - createalarmtableviewcontroller
    
    func getCreateAlarm() -> CreateAlarmTableViewController {
        return CreateAlarmTableViewController(nibName: "CreateAlarmTableViewController", bundle: nil)
    }
    
    func presentCreateAlarm() {
        self.appDelegate.window?.rootViewController = self.getCreateAlarm()
        self.appDelegate.window?.makeKeyAndVisible()
    }
    
    // MARK: - createfriendtableviewcontroller
    
    func getCreateFriend() -> CreateFriendTableViewController {
        return CreateFriendTableViewController(nibName: "CreateFriendTableViewController", bundle: nil)
    }
    
    func presentCreateFriend() {
        self.appDelegate.window?.rootViewController = self.getCreateFriend()
        self.appDelegate.window?.makeKeyAndVisible()
    }
    
    // MARK: - editalarmtableviewcontroller
    
    func getEditAlarm() -> EditAlarmTableViewController {
        return EditAlarmTableViewController(nibName: "EditAlarmTableViewController", bundle: nil)
    }
    
    func presentEditAlarm() {
        self.appDelegate.window?.rootViewController = self.getEditAlarm()
        self.appDelegate.window?.makeKeyAndVisible()
    }
    
    func presentEditAlarm(alarm: Alarm) {
        let editAlarm = self.getEditAlarm()
        editAlarm.alarm = alarm
        self.appDelegate.window?.rootViewController = editAlarm
        self.appDelegate.window?.makeKeyAndVisible()
    }
    
    // MARK: - customalarmviewcontroller
    
    func getCustomAlarm() -> CustomAlarmViewController {
        return CustomAlarmViewController(nibName: "CustomAlarmViewController", bundle: nil)
    }
    
    func presentCustomAlarm() {
        self.appDelegate.window?.rootViewController = self.getCustomAlarm()
        self.appDelegate.window?.makeKeyAndVisible()
    }
    
    // MARK: - videoalarm
    
    func getVideoAlarm(uid: String) -> VideoAlarmViewController {
        let videoAlarm = VideoAlarmViewController(nibName: "VideoAlarmViewController", bundle: nil)
        videoAlarm.videoFileName = uid
        return videoAlarm
    }
    
    func presentVideoAlarm(uid: String) {
        self.appDelegate.window?.rootViewController = self.getVideoAlarm(uid)
        self.appDelegate.window?.makeKeyAndVisible()
    }
    
    // MARK: - tutorial
    
    func getTutorial() -> TutorialViewController {
        return TutorialViewController(nibName: "TutorialViewController", bundle: nil)
    }
    
    func presentTutorial() {
        self.appDelegate.window?.rootViewController = self.getTutorial()
        self.appDelegate.window?.makeKeyAndVisible()
    }
    
}