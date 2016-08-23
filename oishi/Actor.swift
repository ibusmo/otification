//
//  Actor.swift
//  oishi
//
//  Created by warinporn khantithamaporn on 8/22/2559 BE.
//  Copyright © 2559 com.rollingneko. All rights reserved.
//

import Foundation

class Actor {
    
    var name: String?
    var actorName: String?
    var imageName: String?
    var image: UIImage?
    
    init(name: String?, actorName: String?, imageName: String?) {
        self.name = name
        self.actorName = actorName
        self.imageName = imageName
        if let imageName = imageName {
            self.image = UIImage(named: imageName)
        }
    }
    
}