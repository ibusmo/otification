//
//  PopupView.swift
//  OISHI
//
//  Created by warinporn khantithamaporn on 8/30/2559 BE.
//  Copyright © 2559 com.rollingneko. All rights reserved.
//

import UIKit

class PopupView: UIView {

    var backgroundImageView = UIImageView()
    var popupImageView = UIImageView()
    var closeButton = UIButton()
    
    var messageLabel = THLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.zPosition = 901
        
        self.backgroundColor = UIColor.clearColor()
        
        self.backgroundImageView.frame = frame
        self.backgroundImageView.image = UIImage(named: "popup_bg")
        self.backgroundImageView.layer.zPosition = 902
        self.backgroundImageView.backgroundColor = UIColor.clearColor()
        
        self.popupImageView.frame = frame
        self.popupImageView.layer.zPosition = 903
        self.popupImageView.backgroundColor = UIColor.clearColor()
        
        let closeButtonSize = CGSizeMake(Otification.calculatedWidthFromRatio(188.0), Otification.calculatedWidthFromRatio(188.0))
        self.closeButton.frame = CGRectMake(Otification.rWidth - closeButtonSize.width - Otification.calculatedWidthFromRatio(25.0), Otification.calculatedHeightFromRatio(550.0), closeButtonSize.width, closeButtonSize.height)
        self.closeButton.layer.zPosition = 1000
        self.closeButton.backgroundColor = UIColor.clearColor()
        self.closeButton.addTarget(self, action: #selector(PopupView.closeButtonDidTap), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.addSubview(self.backgroundImageView)
        self.addSubview(self.popupImageView)
        self.addSubview(self.closeButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initPopupView(message: String) {
        self.messageLabel.frame = CGRectMake(Otification.calculatedWidthFromRatio(211.0), Otification.calculatedHeightFromRatio(890.0), Otification.calculatedWidthFromRatio(820.0), Otification.calculatedHeightFromRatio(612.0))
        self.messageLabel.font = UIFont(name: Otification.DBHELVETHAICA_X_BOLD, size: Otification.calculatedHeightFromRatio(120.0))
        self.messageLabel.textAlignment = .Center
    }
    
    func closeButtonDidTap() {
        self.removeFromSuperview()
    }

}
