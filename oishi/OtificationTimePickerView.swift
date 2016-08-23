//
//  OtificationTimePickerView.swift
//  oishi
//
//  Created by warinporn khantithamaporn on 8/17/2559 BE.
//  Copyright © 2559 com.rollingneko. All rights reserved.
//

import UIKit
import PickerView

class OtificationTimePickerView: UIView, PickerViewDataSource, PickerViewDelegate {

    var hourPickerView = PickerView(frame: CGRectMake(0.0, 0.0, (230.0 / 1242.0) * UIScreen.mainScreen().bounds.size.width , (568.0 / 2208.0) * UIScreen.mainScreen().bounds.size.height))
    
    var minutePickerView = UIPickerView()
    
    init() {
        super.init(frame: CGRectMake(0.0, 0.0, UIScreen.mainScreen().bounds.size.width, (568.0 / 2208.0) * UIScreen.mainScreen().bounds.size.height))
        
        self.hourPickerView.backgroundColor = UIColor.blackColor()
        self.hourPickerView.dataSource = self
        self.hourPickerView.delegate = self
        
        self.addSubview(self.hourPickerView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - set hour and minute picker to current time
    
    /*
    func setPickersView() {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "hh mm"
        let timeString = formatter.stringFromDate(NSDate())
        let times = timeString.characters.split{$0 == " "}.map(String.init)
        
        // self.hourPickerView.selectRow(selectedHour, animated: false)
    }
     */
    
    func pickerViewNumberOfRows(pickerView: PickerView) -> Int {
        return 24
    }
    
    func pickerView(pickerView: PickerView, titleForRow row: Int, index: Int) -> String {
        return "What the fuck"
    }
    
    func pickerViewHeightForRows(pickerView: PickerView) -> CGFloat {
        return 20.0
    }
    
    func pickerView(pickerView: PickerView, styleForLabel label: UILabel, highlighted: Bool) {
        if highlighted {
            label.font = UIFont.systemFontOfSize(25.0)
            label.textColor = UIColor.redColor()
        } else {
            label.font = UIFont.systemFontOfSize(15.0)
            label.textColor = .lightGrayColor()
        }
    }
    
    func pickerView(pickerView: PickerView, didSelectRow row: Int, index: Int) {
    }
    
    /*
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView == self.hourPickerView) {
            return 24 * 100
        } else {
            return 60
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row % 24)"
    }
    */

}
