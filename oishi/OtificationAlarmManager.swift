//
//  OtificationAlarmManager.swift
//  oishi
//
//  Created by warinporn khantithamaporn on 8/13/2559 BE.
//  Copyright © 2559 com.rollingneko. All rights reserved.
//

import Foundation
import UIKit

class OtificationAlarmManager {
    
    static let sharedInstance = OtificationAlarmManager()
    
    private init() {}
    
    func checkPushNotificationPermission() -> Bool {
        let settings = UIApplication.sharedApplication().currentUserNotificationSettings()
        if settings!.types == .None {
            let notificationSettings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
            UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
            return true
        }
        return true
    }
    
    func setAlarmSchedule() {
        
    }
    
}