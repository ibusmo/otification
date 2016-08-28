//
//  GalleryActorView.swift
//  oishi
//
//  Created by warinporn khantithamaporn on 8/28/2559 BE.
//  Copyright © 2559 com.rollingneko. All rights reserved.
//

import UIKit

class GalleryActorView: UIView {

    var actorImage = UIImageView()          // z = 1000
    var actorBackground = UIImageView()     // z = 250
    var selectedBackground = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.shadowColor = UIColor.blackColor().CGColor
        self.layer.shadowOffset = CGSizeMake(2.0, 2.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.3
        
        self.backgroundColor = UIColor.clearColor()
        self.actorImage.backgroundColor = UIColor.clearColor()
        self.actorBackground.backgroundColor = UIColor.clearColor()
        self.selectedBackground.backgroundColor = UIColor.clearColor()
        
        self.actorImage.frame = CGRectMake(-0.5, -0.5, frame.size.width + 1.0, frame.size.height + 2.0)
        self.actorBackground.frame = CGRectMake(0.0, 0.0, frame.size.width, frame.size.height)
        self.selectedBackground.frame = CGRectMake(0.0, 0.0, frame.size.width, frame.size.height)
        
        self.actorImage.layer.zPosition = 1000
        self.actorBackground.layer.zPosition = 0
        self.selectedBackground.layer.zPosition = 500
        
        self.actorBackground.image = UIImage(named: "gallery_actor")
        self.selectedBackground.image = UIImage(named: "gallery_actor_active")
        
        self.selectedBackground.alpha = 0.0
        
        self.addSubview(self.actorImage)
        self.addSubview(self.actorBackground)
        self.addSubview(self.selectedBackground)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
