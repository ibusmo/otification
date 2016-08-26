//
//  Otification.swift
//  oishi
//
//  Created by warinporn khantithamaporn on 8/13/2559 BE.
//  Copyright © 2559 com.rollingneko. All rights reserved.
//

import Foundation
import UIKit

class Otification {
    
    static let isiPadSize: Bool = UIScreen.mainScreen().bounds.size.height / UIScreen.mainScreen().bounds.size.width < 1.5
    
    static let dWidth: CGFloat = 1242.0
    static let dHeight: CGFloat = 2208.0
    
    static let rWidth: CGFloat = isiPadSize ? 540.0 : UIScreen.mainScreen().bounds.size.width
    static let rHeight: CGFloat = isiPadSize ? 960.0 : UIScreen.mainScreen().bounds.size.height
    
    static let dNavigationBarSize: CGSize = CGSizeMake(Otification.rWidth, 208.0)
    static let dTabBarSize: CGSize = CGSizeMake(Otification.rWidth, 160.0)
    
    static let navigationBarHeight: CGFloat = (Otification.dNavigationBarSize.height / Otification.dHeight) * Otification.rHeight
    static let tabBarHeight: CGFloat = (Otification.dTabBarSize.height / Otification.dHeight) * Otification.rHeight
    
    static let DBHELVETHAICA_X_REGULAR: String = "DBHelvethaicaX-55Regular"
    static let DBHELVETHAICA_X_REGULAR_ITALIC: String = "DBHelvethaicaX-56Italic"
    static let DBHELVETHAICA_X_MEDIUM: String = "DBHelvethaicaX-65Med"
    static let DBHELVETHAICA_X_MEDIUM_ITALIC: String = "DBHelvethaicaX-66MedIt"
    static let DBHELVETHAICA_X_BOLD: String = "DBHelvethaicaX-75Bd"
    static let DBHELVETHAICA_X_BOLD_ITALIC: String = "DBHelvethaicaX-76BdIt"
    
    static let DBHELVETHAICAMON_X_REGULAR: String = "DBHelvethaicaMonX"
    static let DBHELVETHAICAMON_X_REGULAR_ITALIC: String = "DBHelvethaicaMonX-It"
    static let DBHELVETHAICAMON_X_MEDIUM: String = "DBHelvethaicaMonX-Med"
    static let DBHELVETHAICAMON_X_MEDIUM_ITALIC: String = "DBHelvethaicaMonX-MedIt"
    static let DBHELVETHAICAMON_X_BOLD: String = "DBHelvethaicaMonX-Bd"
    static let DBHELVETHAICAMON_X_BOLD_ITALIC: String = "DBHelvethaicaMonX-BdIt"
    
    static let selfAlarmActions: [Action] = [
        Action(action: "1", actionName: "ตื่นนอน", imageName: "normal_00", activeImageName: "active_00"),
        Action(action: "2", actionName: "ออกกำลังกาย", imageName: "normal_01", activeImageName: "active_01"),
        Action(action: "3", actionName: "อ่านหนังสือ", imageName: "normal_02", activeImageName: "active_02"),
        Action(action: "4", actionName: "ฝันดี", imageName: "normal_03", activeImageName: "active_03"),
        Action(action: "5", actionName: "นัดนู่นนี่นั่น", imageName: "normal_04", activeImageName: "active_04")
    ]
   
    static let friendAlarmActions: [Action] = [
        Action(action: "1", actionName: "HBD", imageName: "f_normal_00", activeImageName: "f_active_00"),
        Action(action: "2", actionName: "คิดถึง", imageName: "f_normal_01", activeImageName: "f_active_01"),
        Action(action: "3", actionName: "ฝันดี", imageName: "f_normal_02", activeImageName: "f_active_02"),
        Action(action: "4", actionName: "ให้กำลังใจ", imageName: "f_normal_03", activeImageName: "f_active_03"),
        Action(action: "5", actionName: "ชวนเที่ยว", imageName: "f_normal_04", activeImageName: "f_active_04"),
        Action(action: "6", actionName: "ง้อ", imageName: "f_normal_05", activeImageName: "f_active_05"),
        Action(action: "7", actionName: "ขอบคุณ", imageName: "f_normal_06", activeImageName: "f_active_06"),
        Action(action: "8", actionName: "Take Care", imageName: "f_normal_07", activeImageName: "f_active_07")
    ]
    
    static let actors: [Actor] = [
        Actor(name: "1", actorName: "พุฒ พุฒิชัย", imageName: "actor_00"),
        Actor(name: "2", actorName: "ต่อ ธนภพ", imageName: "actor_01"),
        Actor(name: "3", actorName: "มาร์ช จุฑาวุฒิ", imageName: "actor_02"),
        Actor(name: "4", actorName: "กั้ง วรกร", imageName: "actor_03"),
        Actor(name: "5", actorName: "มุก วรนิษฐ์", imageName: "actor_04"),
        Actor(name: "6", actorName: "ออฟ จุมพล", imageName: "actor_05")
    ]
    
    private init() {}
    
    class func calculatedWidthFromRatio(width: CGFloat) -> CGFloat {
        return (width / Otification.dWidth) * Otification.rWidth
    }
    
    class func calculatedHeightFromRatio(height: CGFloat) -> CGFloat {
        return (height / Otification.dHeight) * Otification.rHeight
    }
    
    class func getAlarmList() -> [String] {
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
    
    class func getAlarm(uid: String) -> (index: Int?, alarm: Alarm?) {
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
    
    class func saveAlarm(alarm: Alarm) -> Bool {
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
    
    class func deleteAlarm(uid: String) -> Bool {
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