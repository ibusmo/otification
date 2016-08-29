//
//  EditAlarmTableViewCell.swift
//  oishi
//
//  Created by warinporn khantithamaporn on 8/20/2559 BE.
//  Copyright © 2559 com.rollingneko. All rights reserved.
//

import UIKit

protocol EditAlarmTableViewCellDelegate {
    func sound(on: Bool)
    func vibrate(on: Bool)
    func snooze(on: Bool)
}

class EditAlarmTableViewCell: UITableViewCell, ToggleButtonDelegate {
    
    var topSeparator: UIView = UIView()
    var bottomSeparator: UIView = UIView()

    var title: THLabel = THLabel()
    
    var soundButton: ToggleButton = ToggleButton()
    var vibrateButton: ToggleButton = ToggleButton()
    var repeatButton: ToggleButton = ToggleButton()
    
    var delegate: EditAlarmTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .None
        self.backgroundColor = UIColor.clearColor()
        
        self.title.layer.shadowColor = UIColor.blackColor().CGColor
        self.title.layer.shadowOffset = CGSizeMake(2.0, 2.0)
        self.title.layer.shadowRadius = 2.0
        self.title.layer.shadowOpacity = 0.3
        
        self.soundButton.layer.shadowColor = UIColor.blackColor().CGColor
        self.soundButton.layer.shadowOffset = CGSizeMake(2.0, 2.0)
        self.soundButton.layer.shadowRadius = 2.0
        self.soundButton.layer.shadowOpacity = 0.3
        
        self.vibrateButton.layer.shadowColor = UIColor.blackColor().CGColor
        self.vibrateButton.layer.shadowOffset = CGSizeMake(2.0, 2.0)
        self.vibrateButton.layer.shadowRadius = 2.0
        self.vibrateButton.layer.shadowOpacity = 0.3
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initTitleLabel(title: String, isBottom: Bool) {
    
        let screenSize = CGSizeMake(Otification.rWidth, Otification.rHeight)
        
        self.topSeparator.frame = CGRectMake(Otification.calculatedWidthFromRatio(62.0), 0.0, screenSize.width - (2 * Otification.calculatedWidthFromRatio(62.0)), 1.0)
        self.topSeparator.backgroundColor = UIColor(hexString: "c6c3b1")
        self.contentView.addSubview(self.topSeparator)
        
        if (isBottom) {
            self.bottomSeparator.frame = CGRectMake(Otification.calculatedWidthFromRatio(62.0), self.frame.size.height - 1.0, screenSize.width - (2 * Otification.calculatedWidthFromRatio(62.0)), 1.0)
            self.bottomSeparator.backgroundColor = UIColor(hexString: "c6c3b1")
            self.contentView.addSubview(self.bottomSeparator)
        }
        
        self.title.frame = CGRectMake(Otification.calculatedWidthFromRatio(68.0), Otification.calculatedHeightFromRatio(0.0), screenSize.width - Otification.calculatedWidthFromRatio(220.0), self.frame.size.height)
        self.title.font = UIFont(name: Otification.DBHELVETHAICA_X_BOLD, size: Otification.calculatedHeightFromRatio(76.0))
        self.title.textColor = UIColor.blackColor()
        self.title.text = title
        
        self.title.strokeColor = UIColor.whiteColor()
        self.title.strokeSize = 3.0
        
        self.contentView.addSubview(self.title)
        
    }
    
    func initSoundSettings(title: String, sound: Bool, vibrate: Bool) {
        self.initTitleLabel(title, isBottom: false)
        
        let buttonSize = CGSizeMake(Otification.calculatedWidthFromRatio(147.0), Otification.calculatedHeightFromRatio(147.0))
        
        self.soundButton.frame = CGRectMake(Otification.calculatedWidthFromRatio(836.0), (Otification.calculatedHeightFromRatio(238.0) - buttonSize.height) / 2.0, buttonSize.width, buttonSize.height)
        self.soundButton.initComponent(UIImage(named: "sound_on")!, offImage: UIImage(named: "sound_off")!)
        self.soundButton.state = sound
        self.soundButton.delegate = self
        
        self.vibrateButton.frame = CGRectMake(Otification.calculatedWidthFromRatio(1024.0), (Otification.calculatedHeightFromRatio(238.0) - buttonSize.height) / 2.0, buttonSize.width, buttonSize.height)
        self.vibrateButton.initComponent(UIImage(named: "vibrate_on")!, offImage: UIImage(named: "vibrate_off")!)
        self.vibrateButton.state = vibrate
        self.vibrateButton.delegate = self
        
        self.contentView.addSubview(self.soundButton)
        self.contentView.addSubview(self.vibrateButton)
    }
    
    func initRepeatSetting(title: String) {
        self.initTitleLabel(title, isBottom: true)
        
        let buttonSize = CGSizeMake(Otification.calculatedWidthFromRatio(350.0), Otification.calculatedHeightFromRatio(150.0))
        
        self.repeatButton.frame = CGRectMake(Otification.calculatedWidthFromRatio(830.0), (Otification.calculatedHeightFromRatio(238.0) - buttonSize.height) / 2.0, buttonSize.width, buttonSize.height)
        self.repeatButton.initComponent(UIImage(named: "repeat_on")!, offImage: UIImage(named: "repeat_off")!)
        self.repeatButton.state = false
        
        self.contentView.addSubview(self.repeatButton)
    }
    
    func toggleButtonDidTap(toggleButton: ToggleButton) {
        if (toggleButton.isEqual(self.soundButton)) {
            self.delegate?.sound(toggleButton.state)
        } else if (toggleButton.isEqual(self.vibrateButton)) {
            self.delegate?.vibrate(toggleButton.state)
        } else {
            self.delegate?.sound(toggleButton.state)
        }
    }
    
}
