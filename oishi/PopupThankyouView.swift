//
//  PopupThankyouView.swift
//  OISHI
//
//  Created by warinporn khantithamaporn on 8/30/2559 BE.
//  Copyright © 2559 com.rollingneko. All rights reserved.
//

import UIKit

protocol PopupThankyouViewDelegate {
    func popupDidRemoveFromSuperview()
}

class PopupThankyouView: UIView {
    
    var backgroundImageView = UIImageView()
    var popupImageView = UIImageView()
    var closeButton = UIButton()
    
    var isOnlyThankyou: Bool = true
    
    var delegate: PopupThankyouViewDelegate?

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
        self.closeButton.frame = CGRectMake(Otification.rWidth - closeButtonSize.width - Otification.calculatedWidthFromRatio(25.0), Otification.calculatedHeightFromRatio(713.0), closeButtonSize.width, closeButtonSize.height)
        self.closeButton.layer.zPosition = 1000
        self.closeButton.backgroundColor = UIColor.clearColor()
        self.closeButton.addTarget(self, action: #selector(PopupThankyouView.closeButtonDidTap), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.addSubview(self.backgroundImageView)
        self.addSubview(self.popupImageView)
        self.addSubview(self.closeButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initPopupView() {
        if (self.isOnlyThankyou) {
            self.popupImageView.image = UIImage(named: "popup_only_thx")
        } else {
            self.popupImageView.image = UIImage(named: "popup_thx")
        }
    }
    
    func closeButtonDidTap() {
        self.removeFromSuperview()
        self.delegate?.popupDidRemoveFromSuperview()
    }

}
