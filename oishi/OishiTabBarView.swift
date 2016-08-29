//
//  BottomBarView.swift
//  oishi
//
//  Created by warinporn khantithamaporn on 8/11/2559 BE.
//  Copyright © 2559 com.rollingneko. All rights reserved.
//

import UIKit
import SwiftHEXColors

protocol OishiTabBarViewDelegate {
    func leftButtonDidTap()
    func rightButtonDidTap()
}

class OishiTabBarView: UIView {
    
    private var leftButton: UIButton = UIButton()
    private var rightButton: UIButton = UIButton()
    
    private var leftButtonTitle: String = ""
    private var rightButtonTitle: String = ""
    private var indicator: [String] = ["< ", " >"]
    
    internal var showUnselectedButtonIndicator: Bool = true
    internal var leftButtonSelected: Bool = true
    
    var swapState: Bool = true
    
    var delegate: OishiTabBarViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init() {
        super.init(frame: CGRectMake(0.0, Otification.rHeight - Otification.tabBarHeight, Otification.rWidth, Otification.tabBarHeight))
            
        self.backgroundColor = UIColor(hexString: "0D1708")
        
        let size = CGSizeMake(Otification.rWidth, Otification.tabBarHeight)
        
        let line = UIView(frame: CGRectMake((Otification.rWidth - 2.0) / 2.0, 6.0, 2.0, Otification.tabBarHeight - 10.0))
        line.backgroundColor = UIColor(hexString: "4d514c")
        line.layer.zPosition = 900
        
        self.addSubview(line)
        
        self.leftButton.frame = CGRectMake(0.0, 0.0, size.width / 2.0, size.height)
        self.rightButton.frame = CGRectMake(size.width / 2.0, 0.0, size.width / 2.0, size.height)
        
        self.leftButton.titleLabel?.font = UIFont(name: Otification.DBHELVETHAICA_X_BOLD, size: Otification.calculatedHeightFromRatio(85.0))
        self.rightButton.titleLabel?.font = UIFont(name: Otification.DBHELVETHAICA_X_BOLD, size: Otification.calculatedHeightFromRatio(85.0))
        
        self.leftButton.addTarget(self, action: #selector(OishiTabBarView.leftButtonDidTap), forControlEvents: UIControlEvents.TouchUpInside)
        self.rightButton.addTarget(self, action: #selector(OishiTabBarView.rightButtonDidTap), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.layer.zPosition = 900
        
        self.addSubview(self.leftButton)
        self.addSubview(self.rightButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setBottomBarView(leftButtonTitle: String, rightButtonTitle: String, leftButtonSelected: Bool) {
        self.leftButtonTitle = leftButtonTitle
        self.rightButtonTitle = rightButtonTitle
        self.leftButtonSelected = leftButtonSelected
        
        self.setSelectedButton()
    }
    
    func setBottomBarView(leftButtonTitle: String, rightButtonTitle: String, leftButtonSelected: Bool, leftIndicator: String, rightIndicator: String) {
        self.leftButtonTitle = leftButtonTitle
        self.rightButtonTitle = rightButtonTitle
        self.leftButtonSelected = leftButtonSelected
        
        
        self.leftButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.leftButton.setTitleColor(UIColor(hexString: "4d514c"), forState: UIControlState.Highlighted)
        self.rightButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            self.rightButton.setTitleColor(UIColor(hexString: "4d514c"), forState: UIControlState.Highlighted)
        self.leftButton.setTitle(self.leftButtonTitle, forState: UIControlState.Normal)
        self.rightButton.setTitle(self.rightButtonTitle, forState: UIControlState.Normal)
    }
    
    func setSelectedButton() {
        if (self.leftButtonSelected) {
            self.leftButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            self.rightButton.setTitleColor(UIColor(hexString: "4d514c"), forState: UIControlState.Normal)
            if (self.showUnselectedButtonIndicator) {
                self.leftButton.setTitle(self.leftButtonTitle, forState: UIControlState.Normal)
                self.rightButton.setTitle(self.rightButtonTitle + self.indicator[1], forState: UIControlState.Normal)
            }
        } else {
            self.leftButton.setTitleColor(UIColor(hexString: "4d514c"), forState: UIControlState.Normal)
            self.rightButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            if (self.showUnselectedButtonIndicator) {
                self.leftButton.setTitle(self.indicator[0] + self.leftButtonTitle, forState: UIControlState.Normal)
                self.rightButton.setTitle(self.rightButtonTitle, forState: UIControlState.Normal)
            }
        }
    }
    
    func leftButtonDidTap() {
        self.leftButtonSelected = true
        if (self.swapState) {
            self.setSelectedButton()
        }
        self.delegate?.leftButtonDidTap()
    }
    
    func rightButtonDidTap() {
        self.leftButtonSelected = false
        if (self.swapState) {
            self.setSelectedButton()
        }
        self.delegate?.rightButtonDidTap()
    }

}
