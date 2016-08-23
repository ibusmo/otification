//
//  Alarm.swift
//  oishi
//
//  Created by warinporn khantithamaporn on 8/15/2559 BE.
//  Copyright © 2559 com.rollingneko. All rights reserved.
//

import Foundation

@objc(Alarm)
class Alarm: NSObject, NSCoding {
    
    var uid: String?
    var title: String?
    var date: NSDate?
    var repeats: [Bool]?
    var on: Bool?
    var snooze: Bool?
    
    var sound: Bool?
    var vibrate: Bool?
    
    var soundFilePath: String?
    
    var photoUrl: String?
    var sentToFriend: Bool?
    
    override init() {}
    
    init(uid: String?, title: String?, date: NSDate?, photoUrl: String?) {
        self.uid = uid
        self.title = title
        self.date = date
        self.photoUrl = photoUrl
        
        self.repeats = nil
        self.on = nil
        self.snooze = nil
        self.sound = nil
        self.vibrate = nil
        self.sentToFriend = true
    }
    
    init(uid: String?, title: String?, date: NSDate?, repeats: [Bool]?, on: Bool?, snooze: Bool?, sound: Bool?, vibrate: Bool?, soundFilePath: String?, photoUrl: String?, sentToFriend: Bool?) {
        self.uid = uid
        self.title = title
        self.date = date
        self.repeats = repeats
        self.on = on
        self.snooze = snooze
        self.sound = sound
        self.vibrate = vibrate
        self.soundFilePath = soundFilePath
        self.photoUrl = photoUrl
        self.sentToFriend = sentToFriend
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.uid = aDecoder.decodeObjectForKey("uid") as? String
        self.title = aDecoder.decodeObjectForKey("title") as? String
        self.date = aDecoder.decodeObjectForKey("date") as? NSDate
        if let repeatsString = aDecoder.decodeObjectForKey("repeats") as? String {
            var repeats = [Bool]()
            let splitedString = repeatsString.characters.split{$0 == " "}.map(String.init)
            for string in splitedString {
                if (string == "true") {
                    repeats.append(true)
                } else {
                    repeats.append(false)
                }
            }
            self.repeats = repeats
        } else {
            self.repeats = nil
        }
        self.on = aDecoder.decodeObjectForKey("on") as? Bool
        self.snooze = aDecoder.decodeObjectForKey("snooze") as? Bool
        self.sound = aDecoder.decodeObjectForKey("sound") as? Bool
        self.vibrate = aDecoder.decodeObjectForKey("vibrate") as? Bool
        self.photoUrl = aDecoder.decodeObjectForKey("photoUrl") as? String
        self.sentToFriend = aDecoder.decodeObjectForKey("sentToFriend") as? Bool
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        if let uid = self.uid {
            aCoder.encodeObject(uid, forKey: "uid")
        }
        if let title = self.title {
            aCoder.encodeObject(title, forKey: "title")
        }
        if let date = self.date {
            aCoder.encodeObject(date, forKey: "date")
        }
        if let photoUrl = self.photoUrl {
            aCoder.encodeObject(photoUrl, forKey: "photoUrl")
        }
        
        if let repeats = self.repeats {
            var string = ""
            for r in repeats {
                string += "\(r.boolValue) "
            }
            string = string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            aCoder.encodeObject(string, forKey: "repeats")
        } else {
            aCoder.encodeObject(nil, forKey: "repeats")
        }
        
        if let on = self.on {
            aCoder.encodeObject(on, forKey: "on")
        } else {
            aCoder.encodeObject(nil, forKey: "on")
        }
        
        if let snooze = self.snooze {
            aCoder.encodeObject(snooze, forKey: "snooze")
        } else {
            aCoder.encodeObject(nil, forKey: "snooze")
        }
        
        if let sound = self.sound {
            aCoder.encodeObject(sound, forKey: "sound")
        } else {
            aCoder.encodeObject(nil, forKey: "sound")
        }
        
        if let vibrate = self.vibrate {
            aCoder.encodeObject(vibrate, forKey: "vibrate")
        } else {
            aCoder.encodeObject(nil, forKey: "vibrate")
        }
        
        if let sentToFriend = self.sentToFriend {
            aCoder.encodeObject(sentToFriend, forKey: "sentToFriend")
        } else {
            aCoder.encodeObject(nil, forKey: "sentToFriend")
        }
    }
    
}