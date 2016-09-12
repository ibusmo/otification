//
//  DataManager.swift
//  OISHI
//
//  Created by warinporn khantithamaporn on 8/30/2559 BE.
//  Copyright © 2559 com.rollingneko. All rights reserved.
//

import Foundation

class DataManager {
    
    static let sharedInstance = DataManager()
    
    private init() {}
    
    func setBoolForKey(value: Bool?, key: String) -> Bool {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.removeObjectForKey(key)
        if let value = value {
            defaults.setBool(value, forKey: key)
            return true
        } else {
            return false
        }
    }
    
    func setObjectForKey(value: AnyObject?, key: String) -> Bool {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.removeObjectForKey(key)
        if let value = value {
            defaults.setObject(value, forKey: key)
            return true
        } else {
            return false
        }
    }
    
    func setObjectForKey(value: AnyObject?, key: String, appName: String) -> Bool {
        let defaults = NSUserDefaults.standardUserDefaults()
        let finalKey = "\(appName)_\(key)"
        defaults.removeObjectForKey(finalKey)
        if let value = value {
            defaults.setObject(value, forKey: finalKey)
            return true
        } else {
            return false
        }
    }
    
    func getBoolForKey(key: String) -> Bool {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.boolForKey(key)
    }
    
    func getObjectForKey(key: String) -> AnyObject? {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.objectForKey(key)
    }
    
    func getObjectForKey(key: String, appName: String) -> AnyObject? {
        let defaults = NSUserDefaults.standardUserDefaults()
        let finalKey = "\(appName)_\(key)"
        return defaults.objectForKey(finalKey)
    }
    
    func removeObjectForKey(key: String) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.removeObjectForKey(key)
    }
    
}