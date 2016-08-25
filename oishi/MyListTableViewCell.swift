//
//  MyListTableViewCell.swift
//  oishi
//
//  Created by warinporn khantithamaporn on 8/19/2559 BE.
//  Copyright © 2559 com.rollingneko. All rights reserved.
//

import UIKit

class MyListTableViewCell: UITableViewCell {
    
    var userImageView: UIImageView = UIImageView()
    var toggleButton: ToggleButton = ToggleButton(frame: CGRectMake(Otification.calculatedWidthFromRatio(880.0), (((339.0 / 2208.0) * Otification.rHeight) - (Otification.calculatedHeightFromRatio(210.0))) / 2.0, Otification.calculatedHeightFromRatio(318.0), Otification.calculatedHeightFromRatio(183.0)))
    
    var actionNameLabel: THLabel = THLabel()
    var timeLabel: THLabel = THLabel()
    var repeatLabel: THLabel = THLabel()
    
    let cellSize = CGSizeMake(Otification.rWidth, Otification.calculatedHeightFromRatio(339.0))

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .None
        
        self.userImageView.layer.shadowColor = UIColor.blackColor().CGColor
        self.userImageView.layer.shadowOffset = CGSizeMake(2.0, 2.0)
        self.userImageView.layer.shadowRadius = 2.0
        self.userImageView.layer.shadowOpacity = 0.3
        
        self.actionNameLabel.frame = CGRectMake(Otification.calculatedWidthFromRatio(358.0), Otification.calculatedHeightFromRatio(38.0), Otification.calculatedWidthFromRatio(462.0), 0.0)
        self.actionNameLabel.font = UIFont(name: Otification.DBHELVETHAICA_X_BOLD, size: Otification.calculatedHeightFromRatio(60.0))
        self.actionNameLabel.textColor = UIColor.blackColor()
        self.actionNameLabel.strokeSize = 1.5
        self.actionNameLabel.strokeColor = UIColor.whiteColor()
        // self.actionNameLabel.frame = CGRectIntegral(self.actionNameLabel.frame)
        
        /*
        self.actionNameLabel.layer.shadowColor = UIColor.blackColor().CGColor
        self.actionNameLabel.layer.shadowOffset = CGSizeMake(2.0, 2.0)
        self.actionNameLabel.layer.shadowRadius = 2.0
        self.actionNameLabel.layer.shadowOpacity = 0.3
        */
        
        self.timeLabel.frame = CGRectMake(Otification.calculatedWidthFromRatio(352.0), Otification.calculatedHeightFromRatio(76.0), Otification.calculatedWidthFromRatio(400.0), 0.0)
        self.timeLabel.font = UIFont(name: Otification.DBHELVETHAICA_X_MEDIUM, size: Otification.calculatedHeightFromRatio(126.0))
        self.timeLabel.textColor = UIColor.redColor()
        self.timeLabel.strokeSize = 3.0
        self.timeLabel.strokeColor = UIColor.whiteColor()
        // self.timeLabel.frame = CGRectIntegral(self.actionNameLabel.frame)
        
        /*
        self.timeLabel.layer.shadowColor = UIColor.blackColor().CGColor
        self.timeLabel.layer.shadowOffset = CGSizeMake(2.0, 2.0)
        self.timeLabel.layer.shadowRadius = 2.0
        self.timeLabel.layer.shadowOpacity = 0.3
        */
        
        self.repeatLabel.frame = CGRectMake(Otification.calculatedWidthFromRatio(362.0), Otification.calculatedHeightFromRatio(210.0), Otification.calculatedWidthFromRatio(462.0), 0.0)
        self.repeatLabel.font = UIFont(name: Otification.DBHELVETHAICA_X_MEDIUM, size: Otification.calculatedHeightFromRatio(50.0))
        self.repeatLabel.textColor = UIColor.blackColor()
        // self.repeatLabel.frame = CGRectIntegral(self.actionNameLabel.frame)
        
        self.toggleButton.initComponent(UIImage(named: "toggleSWOpen")!, offImage: UIImage(named: "toggleSWClose")!)
        
        self.contentView.addSubview(self.actionNameLabel)
        self.contentView.addSubview(self.timeLabel)
        self.contentView.addSubview(self.repeatLabel)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initMyList(row: Int, isFriendList: Bool) {
        let userImageSize = CGSizeMake(Otification.calculatedWidthFromRatio(238.0), Otification.calculatedWidthFromRatio(238.0))
        
        self.userImageView.frame = CGRectMake(Otification.calculatedWidthFromRatio(66.0), (self.frame.size.height - userImageSize.height) / 2.0, userImageSize.width, userImageSize.height)
        self.userImageView.layer.borderWidth = 3.0
        self.userImageView.layer.borderColor = UIColor.whiteColor().CGColor
        
        self.userImageView.layer.cornerRadius = userImageSize.height / 2.0
        self.userImageView.clipsToBounds = true
        
        // dummy
        self.userImageView.image = UIImage(named: "profile")
        
        self.contentView.addSubview(self.toggleButton)
        self.contentView.addSubview(self.userImageView)
        
        if (row % 2 == 1) {
            let imageView = UIImageView(frame: self.frame)
            imageView.image = UIImage(named: "mylist_cell_bg_2")
            self.backgroundView = imageView
        } else {
            let imageView = UIImageView(frame: self.frame)
            imageView.image = UIImage(named: "mylist_cell_bg_1")
            self.backgroundView = imageView
        }
    }
    
    func setActionTitle(title: String) {
        self.actionNameLabel.text = title
        self.actionNameLabel.sizeToFit()
        var frame = self.actionNameLabel.frame
        frame.size.width += 10.0
        self.actionNameLabel.frame = frame
    }
    
    func setTime(date: NSDate) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH':'mm"
        self.timeLabel.text = dateFormatter.stringFromDate(date)
        self.timeLabel.sizeToFit()
        var frame = self.timeLabel.frame
        frame.size.width += 10.0
        self.timeLabel.frame = frame
    }
    
    func setRepeat(repeats: [Bool]) {
        let dayInWeek: [String] = ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]
        var repeatText = ""
        for (index, r) in repeats.enumerate() {
            if (r) {
                repeatText += dayInWeek[index] + " "
            }
        }
        self.repeatLabel.text = repeatText
        self.repeatLabel.sizeToFit()
        var frame = self.repeatLabel.frame
        frame.size.width += 10.0
        self.repeatLabel.frame = frame
    }
    
}
