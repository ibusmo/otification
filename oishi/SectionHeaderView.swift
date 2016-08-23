//
//  SectionHeaderView.swift
//  oishi
//
//  Created by warinporn khantithamaporn on 8/11/2559 BE.
//  Copyright © 2559 com.rollingneko. All rights reserved.
//

import UIKit

class SectionHeaderView: UIView {
    
    var headerImageView: UIImageView = UIImageView()
    
    var createAlarmLabel: UILabel = UILabel()
    var createAlarmImageView: UIImageView = UIImageView()
    var createAlarmButton: UIButton = UIButton()

    init() {
        super.init(frame: CGRectMake(0.0, 0.0, Otification.rWidth, Otification.calculatedHeightFromRatio(339.0)))
        
        self.headerImageView.frame = CGRectMake(0.0, -1 * Otification.calculatedHeightFromRatio(208.0), Otification.rWidth, Otification.calculatedHeightFromRatio(547.0))
        self.headerImageView.image = UIImage(named: "section_header")
        
        self.addSubview(self.headerImageView)
        
        self.layer.shadowColor = UIColor.blackColor().CGColor
        self.layer.masksToBounds = false
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSizeMake(0.0, 5.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initCreateAlarm() {
        let screenSize = CGSizeMake(Otification.rWidth, Otification.rHeight)
        let size = CGSizeMake(screenSize.width, Otification.calculatedHeightFromRatio(96.0))
        
        self.createAlarmImageView.frame = CGRectMake(0.0, self.frame.size.height - Otification.calculatedHeightFromRatio(170.0), screenSize.width, size.height)
        self.createAlarmImageView.image = UIImage(named: "createalarm_title")
        
        self.createAlarmButton.setFrameAndImageWithShadow(CGRectMake(Otification.calculatedWidthFromRatio(967.0), (self.frame.size.height - Otification.calculatedHeightFromRatio(190.0)), Otification.calculatedWidthFromRatio(208.0), Otification.calculatedHeightFromRatio(160.0)), image: UIImage(named: "createalarm_button"))
        
        self.addSubview(self.createAlarmImageView)
        self.addSubview(self.createAlarmButton)
    }
    
    func initEditAlarm() {
        let screenSize = CGSizeMake(Otification.rWidth, Otification.rHeight)
        let size = CGSizeMake(screenSize.width, Otification.calculatedHeightFromRatio(96.0))
        
        self.createAlarmImageView.frame = CGRectMake(0.0, self.frame.size.height - Otification.calculatedHeightFromRatio(170.0), screenSize.width, size.height)
        self.createAlarmImageView.image = UIImage(named: "editalarm_title")
        
        self.addSubview(self.createAlarmImageView)
    }

}
