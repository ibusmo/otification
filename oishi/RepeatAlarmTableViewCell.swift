//
//  RepeatAlarmTableViewCell.swift
//  oishi
//
//  Created by warinporn khantithamaporn on 8/19/2559 BE.
//  Copyright © 2559 com.rollingneko. All rights reserved.
//

import UIKit

protocol RepeatAlarmTableViewCellDelegate {
    func toggleButtonAtIndex(index: Int, state: Bool)
}

class RepeatAlarmTableViewCell: UITableViewCell, ToggleButtonDelegate {
    
    var repeatTitleLabel: THLabel = THLabel()
    var buttons: [ToggleButton] = [ToggleButton]()
    var labels: [UILabel] = [UILabel]()
    
    var buttonTitles: [String] = ["อา", "จ", "อ", "พ", "พฤ", "ศ", "ส"]
    var repeats = [Bool](count: 7, repeatedValue: false)
    
    var delegate: RepeatAlarmTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .None
        self.backgroundColor = UIColor.clearColor()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initRepeatAlarm(repeats: [Bool]) {
        self.repeats = repeats
        self.repeatTitleLabel.frame = CGRectMake(Otification.calculatedWidthFromRatio(64.0), Otification.calculatedHeightFromRatio(60.0), Otification.calculatedWidthFromRatio(400.0), 0.0)
        self.repeatTitleLabel.font = UIFont(name: Otification.DBHELVETHAICA_X_BOLD, size: Otification.calculatedHeightFromRatio(76.0))
        self.repeatTitleLabel.textColor = UIColor.blackColor()
        self.repeatTitleLabel.strokeColor = UIColor.whiteColor()
        self.repeatTitleLabel.strokeSize = 2.0
        
        self.repeatTitleLabel.text = "ปลุกซ้ำ"
        self.repeatTitleLabel.sizeToFit()
        
        var xPosition: CGFloat = Otification.calculatedWidthFromRatio(54.0)
        let yPosition: CGFloat = Otification.calculatedHeightFromRatio(188.0)
        let buttonSize = CGSizeMake(Otification.calculatedWidthFromRatio(140.0), Otification.calculatedHeightFromRatio(140.0))
        for i in 0 ..< 7 {
            let button = ToggleButton(frame: CGRectMake(xPosition, yPosition, buttonSize.width, buttonSize.height))
            let title = UILabel(frame: button.frame)
            
            title.textAlignment = .Center
            title.font = UIFont(name: Otification.DBHELVETHAICA_X_BOLD, size: Otification.calculatedHeightFromRatio(66.0))
            title.text = self.buttonTitles[i]
            
            button.initComponent(UIImage(named: "repeat_button_on")!, offImage: UIImage(named: "repeat_button_off")!)
            
            if (repeats[i]) {
                button.state = true
                title.textColor = UIColor.whiteColor()
            } else {
                button.state = false
                title.textColor = UIColor(hexString: "b2f64b")
            }
            
            xPosition += buttonSize.width + Otification.calculatedWidthFromRatio(22.0)
            
            button.delegate = self
            
            button.tag = i
            title.tag = i
            
            self.buttons.append(button)
            self.labels.append(title)
            
            self.contentView.addSubview(button)
            self.contentView.addSubview(title)
        }
        
        self.contentView.addSubview(self.repeatTitleLabel)
    }
    
    func toggleButtonDidTap(toggleButton: ToggleButton) {
        let index = toggleButton.tag
        let label = self.labels[index]
        if (toggleButton.state) {
            label.textColor = UIColor.whiteColor()
            self.repeats[index] = true
            self.delegate?.toggleButtonAtIndex(index, state: true)
        } else {
            label.textColor = UIColor(hexString: "b2f64b")
            self.repeats[toggleButton.tag] = false
            self.delegate?.toggleButtonAtIndex(index, state: false)
        }
    }
    
}
