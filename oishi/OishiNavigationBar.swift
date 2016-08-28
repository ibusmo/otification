//
//  OishiNavigationBar.swift
//  oishi
//
//  Created by warinporn khantithamaporn on 8/11/2559 BE.
//  Copyright © 2559 com.rollingneko. All rights reserved.
//

import UIKit

protocol OishiNavigationBarDelegate {
    func menuDidTap()
}

class OishiNavigationBar: UIView {
    
    var backgroundImageView = UIImageView()
    var logoImageView = UIImageView()
    var greenTeaLeafImageView = UIImageView()
    
    var menuButton = UIButton()
    var menuImageView = UIImageView()
    
    var delegate: OishiNavigationBarDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init() {
        super.init(frame: CGRectMake(0.0, 0.0, Otification.rWidth, Otification.calculatedHeightFromRatio(376.0)))
        
        let screenSize = CGSizeMake(Otification.rWidth, Otification.rHeight)
        
        self.backgroundImageView.frame = CGRectMake(0.0, 0.0, Otification.rWidth, Otification.calculatedHeightFromRatio(265.0))
        self.backgroundImageView.contentMode = UIViewContentMode.ScaleAspectFill
        self.backgroundImageView.image = UIImage(named: "navbar_bg")
        
        self.logoImageView.frame = CGRectMake(0.0, 0.0, Otification.rWidth, Otification.calculatedHeightFromRatio(322.0))
        self.logoImageView.contentMode = UIViewContentMode.ScaleAspectFit
        self.logoImageView.image = UIImage(named: "oishi_logo")
        
        self.greenTeaLeafImageView.frame = CGRectMake(0.0, 0.0, Otification.calculatedWidthFromRatio(253.0), Otification.calculatedHeightFromRatio(402.0))
        self.greenTeaLeafImageView.contentMode = UIViewContentMode.ScaleAspectFit
        self.greenTeaLeafImageView.image = UIImage(named: "new_green_tea")
        
        let menuImageViewSize = CGSizeMake(Otification.calculatedWidthFromRatio(108.0), Otification.calculatedHeightFromRatio(92.0))
        self.menuImageView.frame = CGRectMake(screenSize.width - Otification.calculatedWidthFromRatio(168.0), (Otification.calculatedHeightFromRatio(208.0) - Otification.calculatedHeightFromRatio(92.0)) / 2.0, menuImageViewSize.width, menuImageViewSize.height)
        self.menuImageView.image = UIImage(named: "menu")
        
        let menuButtonSize = CGSizeMake(Otification.calculatedWidthFromRatio(208.0), Otification.calculatedHeightFromRatio(208.0))
        self.menuButton.frame = CGRectMake(screenSize.width - Otification.calculatedWidthFromRatio(208.0), 0.0, menuButtonSize.width, menuButtonSize.height)
        self.menuButton.addTarget(self, action: #selector(OishiNavigationBar.menuDidTap), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.layer.zPosition = 1000
        
        self.addSubview(self.backgroundImageView)
        self.addSubview(self.logoImageView)
        self.addSubview(self.menuImageView)
        self.addSubview(self.menuButton)
        self.addSubview(self.greenTeaLeafImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func menuDidTap() {
        self.delegate?.menuDidTap()
    }

}
