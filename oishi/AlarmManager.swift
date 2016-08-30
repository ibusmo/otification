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
    
    var friendList: [String] = [String]()
    var friendAlarms: [Alarm] = [Alarm]()
    
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
        
        var counter: Int = 0
        
        for (index, r) in alarm.repeats!.enumerate() {
            if (!r) {
                counter += 1
            } else {
                let notification = UILocalNotification()
                
                // default
                if #available(iOS 8.2, *) {
                    notification.alertTitle = "Otification"
                    if let title = alarm.notiTitle {
                        notification.alertTitle = title
                    }
                } else {
                    // Fallback on earlier versions
                }
                
                notification.alertBody = "It's time to O!" // text that will be displayed in the notification
                notification.alertAction = "turn off" // text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"

                if let message = alarm.notiMessage {
                    notification.alertBody = message
                }
                
                // TODO: check firedate day is not previous today
                notification.fireDate = self.getFireDate(alarm.date!, weekday: index + 1)
                notification.repeatInterval = .Weekday
                
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
            
                if let on = alarm.sound where !on {
                    notification.soundName = "silent.caf"
                }
                
                notification.userInfo = userInfo
                
                UIApplication.sharedApplication().scheduleLocalNotification(notification)
            }
        }
        
        if (counter == 7) {
            let notification = UILocalNotification()
                
                // default
                if #available(iOS 8.2, *) {
                    notification.alertTitle = "Otification"
                    if let title = alarm.notiTitle {
                        notification.alertTitle = title
                    }
                } else {
                    // Fallback on earlier versions
                }
                notification.alertBody = "It's time to O!" // text that will be displayed in the notification
                notification.alertAction = "turn off" // text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"

                if let message = alarm.notiMessage {
                    notification.alertBody = message
                }
                
                // TODO: check firedate day is not previous today
                notification.fireDate = self.getFireDate(alarm.date!)
                
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
            
                if let on = alarm.sound where !on {
                    notification.soundName = "silent.caf"
                }
            
                if let videoFileName = alarm.vdoFileName {
                    userInfo["video"] = videoFileName
                }
                
                notification.userInfo = userInfo
                
                UIApplication.sharedApplication().scheduleLocalNotification(notification)
        }
        
    }
    
    func setAlarm(alarm: Alarm) {
        var counter: Int = 0
        
        for (index, r) in alarm.repeats!.enumerate() {
            if (!r) {
                counter += 1
            } else {
                let notification = UILocalNotification()
                
                // default
                if #available(iOS 8.2, *) {
                    notification.alertTitle = "Otification"
                    if let title = alarm.notiTitle {
                        notification.alertTitle = title
                    }
                } else {
                    // Fallback on earlier versions
                }
                notification.alertBody = "It's time to O!" // text that will be displayed in the notification
                notification.alertAction = "turn off" // text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"

                if let message = alarm.notiMessage {
                    notification.alertBody = message
                }
                
                // TODO: check firedate day is not previous today
                notification.fireDate = self.getFireDate(alarm.date!, weekday: index + 1)
                
                // TODO: if alarm have an soundfilepath use it instead of uid
                var userInfo = Dictionary<String, AnyObject>()
                userInfo["uid"] = alarm.uid!
                userInfo["title"] = alarm.title!
                
                // TODO: if alarm have an soundfilepath use it instead of uid
                
                print("alarm.sound \(alarm.sound)")
                
                if let soundFileName = alarm.soundFileName {
                    notification.soundName = soundFileName
                    userInfo["custom"] = false
                } else {
                    notification.soundName = alarm.uid! + ".caf"
                    userInfo["custom"] = true
                }
            
                if let on = alarm.sound where !on {
                    notification.soundName = "silent.caf"
                }
                
                if let videoFileName = alarm.vdoFileName {
                    userInfo["video"] = videoFileName
                }
                
                notification.userInfo = userInfo
                
                UIApplication.sharedApplication().scheduleLocalNotification(notification)
            }
        }
        
        if (counter == 7) {
            let notification = UILocalNotification()
                
                // default
                if #available(iOS 8.2, *) {
                    notification.alertTitle = "Otification"
                    if let title = alarm.notiTitle {
                        notification.alertTitle = title
                    }
                } else {
                    // Fallback on earlier versions
                }
                notification.alertBody = "It's time to O!" // text that will be displayed in the notification
                notification.alertAction = "turn off" // text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"

                if let message = alarm.notiMessage {
                    notification.alertBody = message
                }
                
                // TODO: check firedate day is not previous today
                notification.fireDate = self.getFireDate(alarm.date!)
                
                // TODO: if alarm have an soundfilepath use it instead of uid
                var userInfo = Dictionary<String, AnyObject>()
                userInfo["uid"] = alarm.uid!
                userInfo["title"] = alarm.title!
                
                // TODO: if alarm have an soundfilepath use it instead of uid
            
                print("alarm.sound \(alarm.sound)")
            
                if let soundFileName = alarm.soundFileName {
                    notification.soundName = soundFileName
                    userInfo["custom"] = false
                } else {
                    notification.soundName = alarm.uid! + ".caf"
                    userInfo["custom"] = true
                }
            
                if let on = alarm.sound where !on {
                    notification.soundName = "silent.caf"
                }
            
                if let videoFileName = alarm.vdoFileName {
                    userInfo["video"] = videoFileName
                }
                
                notification.userInfo = userInfo
                
                UIApplication.sharedApplication().scheduleLocalNotification(notification)
        }
    }
    
    func unsetAlarm(uid: String) {
        let app:UIApplication = UIApplication.sharedApplication()
        for (index, oneEvent) in app.scheduledLocalNotifications!.enumerate() {
            let notification = oneEvent as UILocalNotification
            let userInfo = notification.userInfo! as! [String:AnyObject]
            let uidFromUserInfo = userInfo["uid"]! as! String
            if uidFromUserInfo == uid {
                print("unsetAlarm w/ uid: \(uid) at index: \(index)")
                app.cancelLocalNotification(notification)
            }
        }
    }
    
    func unsetAlarm(uid: String, cb: Callback<Bool>) {
        let app:UIApplication = UIApplication.sharedApplication()
        for (index, oneEvent) in app.scheduledLocalNotifications!.enumerate() {
            let notification = oneEvent as UILocalNotification
            let userInfo = notification.userInfo! as! [String:AnyObject]
            let uidFromUserInfo = userInfo["uid"]! as! String
            if uidFromUserInfo == uid {
                print("unsetAlarm w/ uid: \(uid) at index: \(index)")
                app.cancelLocalNotification(notification)
            }
            cb.callback(true, true, nil, nil)
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
        
        if let uid = alarm.uid where list.count < 8 {
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
        let alarmIndex = self.findAlarm(alarm.uid!)
        
        if (alarmIndex == -1) {
            if let uid = alarm.uid where list.count < 8 {
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
        } else {
            // save edited alarm
            if let uid = alarm.uid {
                defaults.removeObjectForKey(uid)
                defaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(alarm), forKey: alarm.uid!)
                self.alarms[alarmIndex] = alarm
                return true
            } else {
                return false
            }
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
    
    // MARK: - uitilities
    
    func findAlarm(uid: String) -> Int {
        for (index, alarm) in self.alarms.enumerate() {
            if let id = alarm.uid where id == uid {
                return index
            }
        }
        return -1
    }
    
    func setSnoozeAlarm(uid: String) {
        let alarm = AlarmManager.sharedInstance.alarms[self.findAlarm(uid)]
        
        let notification = UILocalNotification()
        
        // default
        if #available(iOS 8.2, *) {
            notification.alertTitle = "Otification"
            if let title = alarm.notiTitle {
                notification.alertTitle = title
            }
        } else {
            // Fallback on earlier versions
        }
        
        notification.alertBody = "It's time to O!" // text that will be displayed in the notification
        notification.alertAction = "turn off" // text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"

        if let message = alarm.notiMessage {
            notification.alertBody = message
        }
        
        // TODO: check firedate day is not previous today
        notification.fireDate = NSDate(timeIntervalSinceNow: 600)
        
        var userInfo = Dictionary<String, AnyObject>()
        userInfo["uid"] = alarm.uid!
        print("alarmManager setAlarm w/ uid: \(alarm.uid!)")
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
    
    // MARK: - test
    
    func removeAllAlarm() {
        for uid in self.list {
            self.deleteAlarm(uid)
        }
        for uid in self.friendList {
            self.deleteFriendAlarm(uid)
        }
    }
    
    // MARK: - getfiredate
    
    func getFireDate(setDate: NSDate) -> NSDate {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH mm dd MM yyyy ee"
        
        let nowDate = NSDate()
        let nowDateString = dateFormatter.stringFromDate(nowDate).characters.split{$0 == " "}.map(String.init)
        
        var setDateString = dateFormatter.stringFromDate(setDate).characters.split{$0 == " "}.map(String.init)
        
        let setHour = Int(setDateString[0])!
        let setMinute = Int(setDateString[1])!
        
        let nowHour = Int(nowDateString[0])!
        let nowMinute = Int(nowDateString[1])!
        
        var fireDate: [Int] = [setHour, setMinute, Int(nowDateString[2])!, Int(nowDateString[3])!, Int(nowDateString[4])!, Int(nowDateString[5])!]
        
        if (setHour < nowHour || (setHour == nowHour && setMinute <= nowMinute)) {
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
        
        print("setNewAlarm w/ date from: \(setDate) to \((calendar?.dateFromComponents(componentsForFireDate))!)")
        
        return (calendar?.dateFromComponents(componentsForFireDate))!
    }
    
    func getFireDate(setDate: NSDate, weekday: Int) -> NSDate {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH mm dd MM yyyy ee"
        
        let nowDate = NSDate()
        let nowDateString = dateFormatter.stringFromDate(nowDate).characters.split{$0 == " "}.map(String.init)
        
        var setDateString = dateFormatter.stringFromDate(setDate).characters.split{$0 == " "}.map(String.init)
        
        let setHour = Int(setDateString[0])!
        let setMinute = Int(setDateString[1])!
        
        let nowHour = Int(nowDateString[0])!
        let nowMinute = Int(nowDateString[1])!
        let nowWeekday = Int(nowDateString[5])!
        
        var fireDate: [Int] = [setHour, setMinute, Int(nowDateString[2])!, Int(nowDateString[3])!, Int(nowDateString[4])!, Int(nowDateString[5])!]
        
        let dayComponent = NSDateComponents()
        
        print("weekday: \(weekday), nowWeekday: \(nowWeekday)")
        
        if (weekday < nowWeekday) {
            dayComponent.day = (7 - nowWeekday) + weekday
        } else if (weekday > nowWeekday) {
            dayComponent.day = weekday - nowWeekday
        } else {
            if (setHour < nowHour || (setHour == nowHour && setMinute <= nowMinute)) {
                dayComponent.day = 7
            } else {
                return self.getFireDate(setDate)
            }
        }
        
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        let nextDate = calendar?.dateByAddingComponents(dayComponent, toDate: NSDate(), options: NSCalendarOptions.MatchFirst)
        let next = dateFormatter.stringFromDate(nextDate!).characters.split{$0 == " "}.map(String.init)
        fireDate[2] = Int(next[2])!
        fireDate[3] = Int(next[3])!
        fireDate[4] = Int(next[4])!
        fireDate[5] = Int(next[5])!
        
        if (fireDate[4] > 2016) {
            fireDate[4] = fireDate[4] - 543
        }
        
        let componentsForFireDate = NSDateComponents()
        componentsForFireDate.weekday = fireDate[5]
        componentsForFireDate.year = fireDate[4]
        componentsForFireDate.month = fireDate[3]
        componentsForFireDate.day = fireDate[2]
        componentsForFireDate.hour = fireDate[0]
        componentsForFireDate.minute = fireDate[1]
        componentsForFireDate.second = 0
        
        print("setNewAlarm w/ date \((calendar?.dateFromComponents(componentsForFireDate))!)")
        
        return (calendar?.dateFromComponents(componentsForFireDate))!
    }
    
    // ----------------------------------- FRIEND ZONE ---------------------------------- //
    
    func getFriendAlarmList() -> [String] {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        var list = [String]()
        if let l: [AnyObject] = defaults.arrayForKey("friend_alarm_list") {
            // desc: check an existing alarmlist
            list = l as! [String]
        } else {
            // desc: - if there's no existing alarmlist, create a new one
            defaults.setObject(list, forKey: "friend_alarm_list")
        }
        
        self.list = list
        return list
    }
    
    func saveFriendAlarmList() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.removeObjectForKey("friend_alarm_list")
        defaults.setObject(list, forKey: "friend_alarm_list")
    }
    
    func getFriendAlarmListToObjects() {
        let list = self.getFriendAlarmList()
        for uid in list {
            let result = self.getFriendAlarm(uid)
            if let _ = result.index, alarm = result.alarm {
                self.friendAlarms.append(alarm)
            }
        }
    }
    
    func getFriendAlarm(uid: String) -> (index: Int?, alarm: Alarm?) {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        let list = self.getFriendAlarmList()
        
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
    
    func saveFriendAlarm(actionName: String, actorNo: String) -> Bool {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        var list: [String] = self.getFriendAlarmList()
        
        let uid = NSUUID().UUIDString
        let newAlarm = Alarm(uid: uid, title: actionName, date: NSDate(), actorNo: actorNo)
        
        list.append(uid)
        defaults.removeObjectForKey("friend_alarm_list")
        defaults.setObject(list, forKey: "friend_alarm_list")
        
        // desc: - save alarm object to userdefaults mapped by alarm.uid
        defaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(newAlarm), forKey: newAlarm.uid!)
        self.friendAlarms.append(newAlarm)
        
        return true
    }
    
    func deleteFriendAlarm(uid: String) -> Bool {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        // desc: - remove alarm.uid from alarm list
        var list: [String] = self.getFriendAlarmList()
        if let index = list.indexOf(uid) {
            list.removeAtIndex(index)
            defaults.removeObjectForKey("friend_alarm_list")
            defaults.setObject(list, forKey: "friend_alarm_list")
        }
        
        // desc: - remove alarm object from userdefaults
        defaults.removeObjectForKey(uid)
        let index = self.findFriendAlarm(uid)
        if (index >= 0) {
            self.friendAlarms.removeAtIndex(index)
        }
        
        return true
    }
    
    func findFriendAlarm(uid: String) -> Int {
        for (index, alarm) in self.friendAlarms.enumerate() {
            if let id = alarm.uid where id == uid {
                return index
            }
        }
        return -1
    }
    
}
