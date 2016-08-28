//
//  EditAlarmTableViewController.swift
//  oishi
//
//  Created by warinporn khantithamaporn on 8/19/2559 BE.
//  Copyright © 2559 com.rollingneko. All rights reserved.
//

import UIKit

class EditAlarmTableViewController: OishiTableViewController, RepeatAlarmTableViewCellDelegate, EditAlarmTableViewCellDelegate {
    
    var alarm: Alarm?

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.registerNib(UINib(nibName: "RepeatAlarmTableViewCell", bundle:  nil), forCellReuseIdentifier: "repeatCell")
        self.tableView.registerNib(UINib(nibName: "EditAlarmTableViewCell", bundle:  nil), forCellReuseIdentifier: "editAlarmCell")
        
        self.tableView.bounces = false
        
        self.backgroundImageView.frame = CGRectMake(0.0, 0.0, self.screenSize.width, self.screenSize.height)
        self.backgroundImageView.image = UIImage(named: "editalarm_bg")
        self.backgroundImageView.contentMode = UIViewContentMode.ScaleAspectFill
        
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        self.showBottomBarView = true
        self.tabBar.swapState = false
        self.tabBar.setBottomBarView("ยกเลิก", rightButtonTitle: "บันทึก", leftButtonSelected: true, leftIndicator: "", rightIndicator: "")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            let cell = tableView.dequeueReusableCellWithIdentifier("repeatCell", forIndexPath: indexPath) as! RepeatAlarmTableViewCell
            cell.delegate = self
            if let repeats = self.alarm!.repeats {
                cell.initRepeatAlarm(repeats)
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("editAlarmCell", forIndexPath: indexPath) as! EditAlarmTableViewCell
            cell.delegate = self
            if (indexPath.row == 1) {
                cell.initSoundSettings("ระบบเสียง")
            } else {
                cell.initRepeatSetting("เตือนทุก 10 นาที")
            }
            return cell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.row == 0) {
            return Otification.calculatedHeightFromRatio(608.0)
        } else {
            return Otification.calculatedHeightFromRatio(238.0)
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = SectionHeaderView()
        header.initEditAlarm()
        return header
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Otification.calculatedHeightFromRatio(339.0)
    }
    
    // MARK: - repeat
    
    func toggleButtonAtIndex(index: Int, state: Bool) {
        print("repeat day button did toggle at \(index) w/ stat \(state)")
        if let alarm = self.alarm {
            alarm.repeats![index] = state
        }
    }
    
    // MARK: - settings button
    
    func sound(on: Bool) {
    }
    
    func vibrate(on: Bool) {
    }
    
    func snooze(on: Bool) {
    }
    
    // MARK: - oishinavigationbardelegate
    
    override func menuDidTap() {
        let menu = MenuTableViewController(nibName: "MenuTableViewController", bundle: nil)
        menu.modalPresentationStyle = .OverCurrentContext
        self.definesPresentationContext = true
        self.presentViewController(menu, animated: false, completion: nil)
    }
    
    // MARK: - tabbar
    
    override func leftButtonDidTap() {
        print("check this")
        ViewControllerManager.sharedInstance.presentMyList()
    }
    
    override func rightButtonDidTap() {
        if let alarm = self.alarm {
            
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
