//
//  MyListTableViewController.swift
//  oishi
//
//  Created by warinporn khantithamaporn on 8/11/2559 BE.
//  Copyright © 2559 com.rollingneko. All rights reserved.
//

import UIKit
import AVFoundation

class MyListTableViewController: OishiTableViewController, ToggleButtonDelegate {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.bounces = false
        
        self.tableView.registerNib(UINib(nibName: "MyListTableViewCell", bundle: nil), forCellReuseIdentifier: "myListCell")
        
        self.backgroundImageView.frame = CGRectMake(0.0, 0.0, self.screenSize.width, self.screenSize.height)
        self.backgroundImageView.image = UIImage(named: "mylist_bg")
        self.backgroundImageView.contentMode = UIViewContentMode.ScaleAspectFill
        
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        self.view.backgroundColor = UIColor.clearColor()
        
        self.showBottomBarView = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()
        
        /*
        let list = Otification.getAlarmList()
        print("list size: \(list.uids.count)")
         */
        
        /*
        let uid = NSUUID().UUIDString
        let alarm = Alarm(uid: uid, title: "title_1", date: NSDate(), repeats: [true, true, false], on: true, snooze: false, sound: false, vibrate: true, soundFileName: nil, photoUrl: nil, sentToFriend: false)
        
        Otification.saveAlarm(alarm)
        let result = Otification.getAlarm(uid)
        if let index = result.index, alarm = result.alarm {
            print("getAlarm: @ index: \(index), alarm: \(alarm.uid) \(alarm.title) \(alarm.date?.description) \(alarm.on) \(alarm.snooze) \(alarm.sound) \(alarm.vibrate) \(alarm.photoUrl) \(alarm.sentToFriend)")
            if let rs = alarm.repeats {
                for (index, r) in rs.enumerate() {
                    print("repeated at: \(index) with \(r)")
                }
            }
        }
        Otification.deleteAlarm(alarm.uid!)
         */
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AlarmManager.sharedInstance.alarms.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("myListCell", forIndexPath: indexPath) as! MyListTableViewCell
        let alarm = AlarmManager.sharedInstance.alarms[indexPath.row]
        cell.initMyList(indexPath.row, isFriendList: false)
        
        cell.toggleButton.delegate = self
        cell.toggleButton.tag = indexPath.row
        
        if let title = alarm.title {
            cell.setActionTitle(title)
        }
        if let date = alarm.date {
            cell.setTime(date)
        }
        if let repeats = alarm.repeats {
            cell.setRepeat(repeats)
        }
        
        if let on = alarm.on {
            cell.toggleButton.state = on
        } else {
            
            cell.toggleButton.state = false
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return Otification.calculatedHeightFromRatio(300.0)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        ViewControllerManager.sharedInstance.presentEditAlarm(AlarmManager.sharedInstance.alarms[indexPath.row])
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = SectionHeaderView()
        header.initCreateAlarm()
        header.createAlarmButton.addTarget(self, action: #selector(MyListTableViewController.createAlarm), forControlEvents: UIControlEvents.TouchUpInside)
        return header
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Otification.calculatedHeightFromRatio(339.0)
    }
    
    // MARK: -
    
    func createAlarm() {
        ViewControllerManager.sharedInstance.presentCreateAlarm()
    }
    
    // MARK: - togglebuttondelegate
    
    func toggleButtonDidTap(toggleButton: ToggleButton) {
        let index = toggleButton.tag
        let alarm = AlarmManager.sharedInstance.alarms[index]
        if (toggleButton.state) {
            AlarmManager.sharedInstance.setAlarm(alarm.uid!)
        } else {
            AlarmManager.sharedInstance.unsetAlarm(alarm.uid!)
        }
        self.tableView.reloadData()
    }

    // MARK: - oishinavigationbardelegate
    
    override func menuDidTap() {
        let menu = MenuTableViewController(nibName: "MenuTableViewController", bundle: nil)
        menu.modalPresentationStyle = .OverCurrentContext
        self.definesPresentationContext = true
        self.presentViewController(menu, animated: true, completion: nil)
    }

}
