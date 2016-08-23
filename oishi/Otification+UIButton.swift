//
//  Otification+UIButton.swift
//  oishi
//
//  Created by warinporn khantithamaporn on 8/18/2559 BE.
//  Copyright © 2559 com.rollingneko. All rights reserved.
//

import Foundation

extension UIButton {
    
    convenience init(frame: CGRect, image: UIImage) {
        self.init(frame: frame)
        self.setImage(image, forState: UIControlState.Normal)
    }
    
    func setFrameAndImageWithShadow(frame: CGRect, image: UIImage?) {
        self.frame = frame
        self.setImage(image, forState: UIControlState.Normal)
        
        self.layer.shadowColor = UIColor.blackColor().CGColor
        self.layer.shadowOffset = CGSizeMake(2.0, 2.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.3
    }
    
}