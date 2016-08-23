//
//  Action.swift
//  oishi
//
//  Created by warinporn khantithamaporn on 8/19/2559 BE.
//  Copyright © 2559 com.rollingneko. All rights reserved.
//

import Foundation

@objc(Action)
class Action: NSObject, NSCoding {
    
    var action: String?
    var actionName: String?
    var imageName: String?
    var activeImageName: String?
    var image: UIImage?
    var activeImage: UIImage?
    
    init(action: String?, actionName: String?, imageName: String?, activeImageName: String?) {
        self.action = action
        self.actionName = actionName
        self.imageName = imageName
        if let imageName = imageName {
            self.image = UIImage(named: imageName)
        }
        if let imageName = activeImageName {
            self.activeImage = UIImage(named: imageName)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.action = aDecoder.decodeObjectForKey("action") as? String
        self.actionName = aDecoder.decodeObjectForKey("actionName") as? String
        self.imageName = aDecoder.decodeObjectForKey("imageName") as? String
        self.activeImageName = aDecoder.decodeObjectForKey("activeImageName") as? String
        if let imageName = self.imageName {
            self.image = UIImage(named: imageName)
        }
        if let imageName = self.activeImageName {
            self.activeImage = UIImage(named: imageName)
        }
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        if let action = self.action {
            aCoder.encodeObject(action, forKey: "action")
        }
        if let actionName = self.actionName {
            aCoder.encodeObject(actionName, forKey: "actionName")
        }
        if let imageName = self.imageName {
            aCoder.encodeObject(imageName, forKey: "imageName")
        }
        if let imageName = self.activeImageName {
            aCoder.encodeObject(imageName, forKey: "activeImageName")
        }
    }
    
}