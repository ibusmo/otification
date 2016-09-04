//
//  PopupThankyouView.swift
//  OISHI
//
//  Created by warinporn khantithamaporn on 8/30/2559 BE.
//  Copyright © 2559 com.rollingneko. All rights reserved.
//

import UIKit

@objc protocol PopupThankyouViewDelegate {
    func popupDidRemoveFromSuperview()
    optional func popupErrorDidRemoveFromSuperview()
    optional func popupFBShareDidTap()
    optional func popupLineShareDidTap()
}

class PopupThankyouView: UIView {
    
    var backgroundImageView = UIImageView()
    var popupImageView = UIImageView()
    var closeButton = UIButton()
    
    var fbButton = UIButton()
    var lineButton = UIButton()
    
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
            self.popupImageView.image = UIImage(named: "popup_thankyou")
            
            let buttonSize = CGSizeMake(Otification.calculatedWidthFromRatio(162.0), Otification.calculatedHeightFromRatio(162.0))
        
            self.fbButton.frame = CGRectMake(Otification.calculatedWidthFromRatio(452.0), Otification.calculatedHeightFromRatio(1295.0), buttonSize.width, buttonSize.height)
            self.fbButton.backgroundColor = UIColor.clearColor()
            self.fbButton.addTarget(self, action: #selector(PopupThankyouView.fbDidTap), forControlEvents: UIControlEvents.TouchUpInside)
            self.fbButton.layer.zPosition = 1000
            
            self.lineButton.frame = CGRectMake(Otification.calculatedWidthFromRatio(642.0), Otification.calculatedHeightFromRatio(1295.0), buttonSize.width, buttonSize.height)
            self.lineButton.backgroundColor = UIColor.clearColor()
            self.lineButton.addTarget(self, action: #selector(PopupThankyouView.lineDidTap), forControlEvents: UIControlEvents.TouchUpInside)
            self.lineButton.layer.zPosition = 1000
            
            self.addSubview(self.fbButton)
            self.addSubview(self.lineButton)
        }
    }
    
    func closeButtonDidTap() {
        self.removeFromSuperview()
        self.delegate?.popupDidRemoveFromSuperview()
    }
    
    func fbDidTap() {
        print("fbDidTap")
        self.delegate?.popupFBShareDidTap!()
    }
    
    func lineDidTap() {
        print("lineDidTap")
        self.delegate?.popupLineShareDidTap!()
    }
    
}
