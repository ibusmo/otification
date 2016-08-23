//
//  AlarmManager.swift
//  oishi
//
//  Created by warinporn khantithamaporn on 8/15/2559 BE.
//  Copyright © 2559 com.rollingneko. All rights reserved.
//

import Foundation
import UIKit

class AlarmManager {
    
    static let sharedInstance = AlarmManager()
    
    private init() {}
    
    // MARK: - nslocalnotification
    
    func setAlarm(alarm: Alarm) {
        
        // todo: - check an existing alarm in notification
        
        // create a corresponding local notification
        let notification = UILocalNotification()
        notification.alertBody = "Alarm \"\(alarm.title!)\"" // text that will be displayed in the notification
        notification.alertAction = "open" // text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"
        
        notification.fireDate = alarm.date // todo item due date (when notification will be fired)
        notification.soundName = UILocalNotificationDefaultSoundName // play default sound
        notification.userInfo = ["uid": alarm.uid!, "title": alarm.title!] // assign a unique identifier to the notification so that we can retrieve it later
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        
    }
    
    func cancelAlarm(alarm: Alarm) {
        if let notifications = UIApplication.sharedApplication().scheduledLocalNotifications {
            for notification in notifications as [UILocalNotification] {
                if let info = notification.userInfo as? [String: String] {
                    if info["uid"] == alarm.uid! {
                        UIApplication.sharedApplication().cancelLocalNotification(notification)
                    }
                }
            }
        }
    }
    
    // MARK: - nsuserdefaults get, set and delete alarm
    
    func getAlarmList() -> [String] {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        var list = [String]()
        if let l: [AnyObject] = defaults.arrayForKey("alarm_list") {
            // desc: check an existing alarmlist
            list = l as! [String]
        } else {
            // desc: - if there's no existing alarmlist, create a new one
            defaults.setObject(list, forKey: "alarm_list")
        }
        
        return list
    }
    
    func getAlarm(uid: String) -> (index: Int?, alarm: Alarm?) {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        let list = self.getAlarmList()
        
        if let index: Int = list.indexOf(uid) {
            if let data = defaults.objectForKey(uid) as? NSData {
                let unarc = NSKeyedUnarchiver(forReadingWithData: data)
                unarc.setClass(Alarm.self, forClassName: "Blog")
                let alarm = unarc.decodeObjectForKey("root") as! Alarm
                return (index, alarm: alarm)
            } else {
                return (nil, nil)
            }
        } else {
            return (nil, nil)
        }
        
    }
    
    func saveAlarm(alarm: Alarm) -> Bool {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        var list: [String] = self.getAlarmList()
        
        if let uid = alarm.uid {
            // desc: - append new alarm list uid, set new alarmlist forkey "alarm_list"
            list.append(uid)
            defaults.removeObjectForKey("alarm_list")
            defaults.setObject(list, forKey: "alarm_list")
            
            // desc: - save alarm object to userdefaults mapped by alarm.uid
            defaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(alarm), forKey: alarm.uid!)
            
            // todo: - notify observers
            
            return true
        } else {
            return false
        }
    }
    
    func deleteAlarm(uid: String) -> Bool {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        // desc: - remove alarm.uid from alarm list
        var list: [String] = self.getAlarmList()
        if let index = list.indexOf(uid) {
            list.removeAtIndex(index)
            defaults.removeObjectForKey("alarm_list")
            defaults.setObject(list, forKey: "alarm_list")
        }
        
        // desc: - remove alarm object from userdefaults
        defaults.removeObjectForKey(uid)
        
        // todo: - notify observers
        
        return true
    }
    
}
