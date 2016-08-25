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
    
    var unsaveAlarm: Alarm?
    
    var list: [String] = [String]()
    var alarms: [Alarm] = [Alarm]()
    
    private init() {}
    
    func prepareNewAlarm(title: String, hour: Int, minute: Int) {
        
        let uid = NSUUID().UUIDString
        self.unsaveAlarm = Alarm(uid: uid)
        self.unsaveAlarm?.title = title
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH mm dd MM yyyy ee"
        let nowDate = NSDate()
        let now = dateFormatter.stringFromDate(nowDate).characters.split{$0 == " "}.map(String.init)
        
        var fireDate: [Int] = [hour, minute, Int(now[2])!, Int(now[3])!, Int(now[4])!, Int(now[5])!]
        
        if (hour < Int(now[0]) || (hour == Int(now[0]) && minute <= Int(now[1]))) {
            let dayComponent = NSDateComponents()
            dayComponent.day = 1
            let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
            let nextDate = calendar?.dateByAddingComponents(dayComponent, toDate: NSDate(), options: NSCalendarOptions.MatchFirst)
            let next = dateFormatter.stringFromDate(nextDate!).characters.split{$0 == " "}.map(String.init)
            fireDate[2] = Int(next[2])!
            fireDate[3] = Int(next[3])!
            fireDate[4] = Int(next[4])!
            fireDate[5] = Int(next[5])!
        }
        
        if (fireDate[4] > 2016) {
            fireDate[4] = fireDate[4] - 543
        }
        
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        let componentsForFireDate = NSDateComponents()
        componentsForFireDate.weekday = fireDate[5]
        componentsForFireDate.year = fireDate[4]
        componentsForFireDate.month = fireDate[3]
        componentsForFireDate.day = fireDate[2]
        componentsForFireDate.hour = fireDate[0]
        componentsForFireDate.minute = fireDate[1]
        componentsForFireDate.second = 0
        
        let notificationDate = calendar?.dateFromComponents(componentsForFireDate)
        let result = dateFormatter.stringFromDate(notificationDate!).characters.split{$0 == " "}.map(String.init)
        
        self.unsaveAlarm?.date = notificationDate
        
        self.unsaveAlarm?.repeats = [false, false, false, false, false, false, false]
        
        self.unsaveAlarm?.sound = true
        self.unsaveAlarm?.vibrate = true
        
        self.unsaveAlarm?.on = true
        
        print("result notificationDate: \(result)")
    }
    
    func setSoundFileNameForUnsaveAlarm() {
        self.unsaveAlarm?.soundFileName = (self.unsaveAlarm?.uid)! + ".caf"
    }
    
    // MARK: - nslocalnotification
    
    // set an existing alarm to on
    func setAlarm(uid: String) {
        
        // todo: - check an existing alarm in notification
        self.alarms[self.findAlarm(uid)].on = true
        let alarm = self.alarms[self.findAlarm(uid)]
        
        print("setAlarm w/ uid: \(uid)")
        
        // create a corresponding local notification
        let notification = UILocalNotification()
        notification.alertBody = "ได้เวลา \"\(alarm.title!)\" จ่ะ :3" // text that will be displayed in the notification
        notification.alertAction = "open" // text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"
        notification.repeatInterval = NSCalendarUnit.Hour
        
        notification.fireDate = alarm.date // todo item due date (when notification will be fired)
        
        // TODO: if alarm have an soundfilepath use it instead of uid
        var userInfo = Dictionary<String, AnyObject>()
        userInfo["uid"] = alarm.uid!
        userInfo["title"] = alarm.title!
        
        // TODO: if alarm have an soundfilepath use it instead of uid
        if let soundFileName = alarm.soundFileName {
            notification.soundName = soundFileName
            userInfo["custom"] = false
        } else {
            notification.soundName = alarm.uid! + ".caf"
            userInfo["custom"] = true
        }
        
        if let videoFileName = alarm.vdoFileName {
            userInfo["video"] = videoFileName
        }
        
        notification.userInfo = userInfo
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        
    }
    
    func setAlarm(alarm: Alarm) {
        
        // todo: - check an existing alarm in notification
        
        // create a corresponding local notification
        let notification = UILocalNotification()
        notification.alertBody = "ได้เวลา \"\(alarm.title!)\" จ่ะ :3" // text that will be displayed in the notification
        notification.alertAction = "open" // text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"
        notification.repeatInterval = NSCalendarUnit.Hour
        
        notification.fireDate = alarm.date // todo item due date (when notification will be fired)
        
        var userInfo = Dictionary<String, AnyObject>()
        userInfo["uid"] = alarm.uid!
        userInfo["title"] = alarm.title!
        
        // TODO: if alarm have an soundfilepath use it instead of uid
        if let soundFileName = alarm.soundFileName {
            notification.soundName = soundFileName
            userInfo["custom"] = false
        } else {
            notification.soundName = alarm.uid! + ".caf"
            userInfo["custom"] = true
        }
        
        if let videoFileName = alarm.vdoFileName {
            userInfo["video"] = videoFileName
        }
        
        notification.userInfo = userInfo
        // notification.userInfo = ["uid": alarm.uid!, "title": alarm.title!, "custom": false] // assign a unique identifier to the notification so that we can retrieve it later
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        
    }
    
    func unsetAlarm(uid: String) {
        let index = self.findAlarm(uid)
        self.alarms[index].on = false
        
        let app:UIApplication = UIApplication.sharedApplication()
        for oneEvent in app.scheduledLocalNotifications! {
            let notification = oneEvent as UILocalNotification
            let userInfo = notification.userInfo! as! [String:AnyObject]
            let uidFromUserInfo = userInfo["uid"]! as! String
            if uidFromUserInfo == uid {
                print("unsetAlarm w/ uid: \(uid)")
                NSNotificationCenter.defaultCenter().postNotificationName("alarmUpdate", object: nil)
                app.cancelLocalNotification(notification)
                break;
            }
        }
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
        
        self.list = list
        
        return list
    }
    
    func saveAlarmList() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.removeObjectForKey("alarm_list")
        defaults.setObject(list, forKey: "alarm_list")
    }
    
    func getAlarmListToObjects() {
        let list = self.getAlarmList()
        for uid in list {
            let result = self.getAlarm(uid)
            if let _ = result.index, alarm = result.alarm {
                self.alarms.append(alarm)
            }
        }
        print("number of alarm: \(self.alarms.count)")
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
    
    func saveAlarm() -> Bool {
        let alarm = self.unsaveAlarm!
        let defaults = NSUserDefaults.standardUserDefaults()
        
        var list: [String] = self.getAlarmList()
        
        if let uid = alarm.uid {
            // desc: - append new alarm list uid, set new alarmlist forkey "alarm_list"
            list.append(uid)
            defaults.removeObjectForKey("alarm_list")
            defaults.setObject(list, forKey: "alarm_list")
            
            // desc: - save alarm object to userdefaults mapped by alarm.uid
            defaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(alarm), forKey: alarm.uid!)
            self.alarms.append(alarm)
            self.setAlarm(alarm)
            
            // todo: - notify observers
            self.unsaveAlarm = nil
            
            return true
        } else {
            return false
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
            self.alarms.append(alarm)
            self.setAlarm(alarm)
            
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
        let index = self.findAlarm(uid)
        if (index >= 0) {
            self.alarms.removeAtIndex(index)
        }
        
        // todo: - notify observers
        
        return true
    }
    
    func findAlarm(uid: String) -> Int {
        for (index, alarm) in self.alarms.enumerate() {
            if let id = alarm.uid where id == uid {
                return index
            }
        }
        return -1
    }
    
    // MARK: - test
    
    func removeAllAlarm() {
        for uid in self.list {
            self.deleteAlarm(uid)
        }
    }
    
}
