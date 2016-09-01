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
    
    func presentMyList(isPresentMyList: Bool) {
        let mylist = self.getMyList()
        mylist.isPresentMyList = isPresentMyList
        if (isPresentMyList) {
            mylist.tabBar.leftButtonDidTap()
        } else {
            mylist.tabBar.rightButtonDidTap()
        }
        self.appDelegate.window?.rootViewController = mylist
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
    
    func getCustomAlarm(actionId: String) -> CustomAlarmViewController {
        let custom = CustomAlarmViewController(nibName: "CustomAlarmViewController", bundle: nil)
        custom.action = actionId
        return custom
    }
    
    func presentCustomAlarm(actionId: String) {
        self.appDelegate.window?.rootViewController = self.getCustomAlarm(actionId)
        self.appDelegate.window?.makeKeyAndVisible()
    }
    
    // MARK: - videoalarm
    
    func getVideoAlarm(fileName: String, uid: String) -> VideoAlarmViewController {
        let videoAlarm = VideoAlarmViewController(nibName: "VideoAlarmViewController", bundle: nil)
        videoAlarm.videoFileName = fileName
        videoAlarm.uid = uid
        return videoAlarm
    }
    
    func presentVideoAlarm(fileName: String, uid: String) {
        self.appDelegate.window?.rootViewController = self.getVideoAlarm(fileName, uid: uid)
        self.appDelegate.window?.makeKeyAndVisible()
    }
    
    // MARK: - gallery
    
    func getGallery() -> GalleryTableViewController {
        return GalleryTableViewController(nibName: "GalleryTableViewController", bundle: nil)
    }
    
    func presentGallery() {
        self.appDelegate.window?.rootViewController = self.getGallery()
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
    
    func getTutorial(numberOfTutorial: Int) -> TutorialViewController {
        let tutorial = TutorialViewController(nibName: "TutorialViewController", bundle: nil)
        tutorial.numberOfTutorial = numberOfTutorial
        return tutorial
    }
    
    func presentTutorial(numberOfTutorial: Int) {
        self.appDelegate.window?.rootViewController = self.getTutorial(numberOfTutorial)
        self.appDelegate.window?.makeKeyAndVisible()
    }
    
    // MARK: - index
    
    func getIndex() -> IndexViewController {
        return IndexViewController(nibName: "IndexViewController", bundle: nil)
    }
    
    func presentIndex() {
        self.appDelegate.window?.rootViewController = self.getIndex()
        self.appDelegate.window?.makeKeyAndVisible()
    }
    
    // MARK: - videopreview
    
    func getVideoPreview(videoUrlString: String) -> VideoPreviewViewController {
        let videoPreview = VideoPreviewViewController(nibName: "VideoPreviewViewController", bundle: nil)
        videoPreview.videoUrlString = videoUrlString
        return videoPreview
    }
    
    func presentVideoPreview(videoUrlString: String) {
        self.appDelegate.window?.rootViewController = self.getVideoPreview(videoUrlString)
        self.appDelegate.window?.makeKeyAndVisible()
    }
    
}