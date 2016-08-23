//
//  TimePickerTableViewCell.swift
//  oishi
//
//  Created by warinporn khantithamaporn on 8/17/2559 BE.
//  Copyright © 2559 com.rollingneko. All rights reserved.
//

import UIKit
import PickerView

protocol TimePickerTableViewCellDelegate {
    func didSelectHour(hour: Int)
    func didSelectMinute(minute: Int)
}

class TimePickerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var hourPickerView: PickerView!
    @IBOutlet weak var minutePickerView: PickerView!
    
    var delegate: TimePickerTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // self.hourPickerView.frame = CGRectMake(0.0, 100.0, UIScreen.mainScreen().bounds.size.width, (568.0 / 2208.0) * UIScreen.mainScreen().bounds.size.height)
        
        self.selectionStyle = UITableViewCellSelectionStyle.None
        
        self.backgroundColor = UIColor.clearColor()
        
        let backgroundImageView  = UIImageView(frame: CGRectMake(0.0, 0.0, Otification.rWidth, Otification.calculatedHeightFromRatio(405.0)))
        backgroundImageView.backgroundColor = UIColor.clearColor()
        backgroundImageView.image = UIImage(named: "timepicker")
        
        self.hourPickerView.backgroundColor = UIColor.clearColor()
        self.hourPickerView.dataSource = self
        self.hourPickerView.delegate = self
        
        self.minutePickerView.backgroundColor = UIColor.clearColor()
        self.minutePickerView.dataSource = self
        self.minutePickerView.delegate = self
        
        print("hourPickerView.frame: \(self.hourPickerView.bounds)")
        
        self.setPickersView()
        
        self.contentView.addSubview(backgroundImageView)
        self.contentView.sendSubviewToBack(backgroundImageView)
        // self.contentView.addSubview(self.hourPickerView)
    }
    
    func setPickersView() {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "HH mm"
        let timeString = formatter.stringFromDate(NSDate())
        let times = timeString.characters.split{$0 == " "}.map(String.init)
        
        self.hourPickerView.selectRow(Int(times[0])!, animated: false)
        self.minutePickerView.selectRow((60 * 25) + Int(times[1])!, animated: false)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}

extension TimePickerTableViewCell: PickerViewDataSource {
    
    // MARK: - PickerViewDataSource
    
    func pickerViewNumberOfRows(pickerView: PickerView) -> Int {
        if (pickerView == self.hourPickerView) {
            return 24
        } else {
            return 60 * 50
        }
    }
    
    func pickerView(pickerView: PickerView, titleForRow row: Int, index: Int) -> String {
        if (pickerView == self.hourPickerView) {
            return "\(row)"
        } else {
            return "\(row % 60 < 10 ? "0\(row % 60)" : "\(row % 60)")"
        }
    }
    
}

extension TimePickerTableViewCell: PickerViewDelegate {
    
    // MARK: - PickerViewDelegate
    
    func pickerViewHeightForRows(pickerView: PickerView) -> CGFloat {
        return Otification.calculatedHeightFromRatio(116.0)
    }
    
    func pickerView(pickerView: PickerView, didSelectRow row: Int, index: Int) {
        if (pickerView.isEqual(self.hourPickerView)) {
            self.delegate?.didSelectHour(row)
        } else {
            self.delegate?.didSelectMinute(row % 60)
        }
    }
    
    func pickerView(pickerView: PickerView, styleForLabel label: UILabel, highlighted: Bool) {
        if (highlighted) {
            label.font = UIFont(name: Otification.DBHELVETHAICA_X_MEDIUM, size: Otification.calculatedHeightFromRatio(164.0))
            label.textColor = UIColor.whiteColor()
        } else {
            label.font = UIFont(name: Otification.DBHELVETHAICA_X_REGULAR, size: Otification.calculatedHeightFromRatio(134.0))
            label.textColor = UIColor.blackColor()
        }
    }
    
}