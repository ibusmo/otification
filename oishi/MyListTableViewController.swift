//
//  MyListTableViewController.swift
//  oishi
//
//  Created by warinporn khantithamaporn on 8/11/2559 BE.
//  Copyright © 2559 com.rollingneko. All rights reserved.
//

import UIKit
import AVFoundation

class MyListTableViewController: OishiTableViewController, ToggleButtonDelegate, SWTableViewCellDelegate {
    
    var isPresentMyList: Bool = true
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        let frame = CGRectMake(0.0, 0.0, Otification.rWidth, Otification.rHeight)
        self.view = UIView(frame: frame)
        self.tableView = UITableView(frame: frame, style: .Plain)
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.bounces = false
        
        self.tableView.backgroundColor = UIColor.clearColor()
        
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
    }
    
    override func viewDidAppear(animated: Bool) {
        // self.tableView.frame = CGRectMake(0.0, 0.0, Otification.dWidth, Otification.dHeight)
        super.viewDidAppear(animated)
        OtificationGoogleAnalytics.sharedInstance.sendGoogleAnalyticsEventTracking(.Page, action: .Opened, label: "page_list")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.isPresentMyList) {
            return AlarmManager.sharedInstance.alarms.count
        } else {
            return AlarmManager.sharedInstance.friendAlarms.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("myListCell", forIndexPath: indexPath) as! MyListTableViewCell
        
        if (self.isPresentMyList) {
            let alarm = AlarmManager.sharedInstance.alarms[indexPath.row]
            cell.initMyList(indexPath.row, isFriendList: false)
            cell.delegate = self
            cell.tag = indexPath.row
            
            cell.toggleButton.delegate = self
            cell.toggleButton.tag = indexPath.row
            
            cell.setLeftUtilityButtons(self.leftbuttons() as [AnyObject], withButtonWidth: Otification.calculatedWidthFromRatio(318.0))
            
            // TODO: - swipe to delete from right
            
            if let title = alarm.title {
                cell.setActionTitle(title)
            }
            if let date = alarm.date {
                cell.setTime(date)
            }
            if let repeats = alarm.repeats {
                cell.setRepeat(repeats)
            }
            
            if let no = alarm.actorNo {
                cell.userImageView.image = UIImage(named: "actorc_\(no)")
            }
            
            if let custom = alarm.custom where custom == true {
                let url = self.getVideoPathString()?.URLByAppendingPathComponent(alarm.uid!).URLByAppendingPathExtension("mov")
                print("getFuckingVideoURL")
                print(url?.absoluteString)
                let asset = AVAsset(URL: url!)
                let imageGenerator = AVAssetImageGenerator(asset: asset)
                let time = CMTimeMake(1, 1)
                let imageRef = try! imageGenerator.copyCGImageAtTime(time, actualTime: nil)
                let thumbnail = UIImage(CGImage: imageRef,  scale: 1.0, orientation: UIImageOrientation.Right)
                cell.userImageView.image = thumbnail
                cell.userImageView.contentMode = .ScaleAspectFill
            }
            
            if let on = alarm.on {
                cell.toggleButton.state = on
            } else {
                cell.toggleButton.state = false
            }
        } else {
            let alarm = AlarmManager.sharedInstance.friendAlarms[indexPath.row]
            cell.initMyList(indexPath.row, isFriendList: true)
            cell.delegate = self
            cell.tag = indexPath.row
            
            cell.setLeftUtilityButtons(self.leftbuttons() as [AnyObject], withButtonWidth: Otification.calculatedWidthFromRatio(318.0))
            
            if let title = alarm.title {
                cell.setActionTitle(title)
            }
            if let date = alarm.date {
                cell.setTime(date)
            }
            if let no = alarm.actorNo {
                cell.userImageView.image = UIImage(named: "actorc_\(no)")
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return Otification.calculatedHeightFromRatio(300.0)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (self.isPresentMyList) {
            ViewControllerManager.sharedInstance.presentEditAlarm(AlarmManager.sharedInstance.alarms[indexPath.row])
        }
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
        OtificationGoogleAnalytics.sharedInstance.sendGoogleAnalyticsEventTracking(.Button, action: .Clicked, label: "bnt_list_crebnt_list_create")
        if (self.tabBar.leftButtonSelected) {
            ViewControllerManager.sharedInstance.presentCreateAlarm()
        } else {
            ViewControllerManager.sharedInstance.presentCreateFriend()
        }
    }
    
    // MARK: - togglebuttondelegate
    
    func toggleButtonDidTap(toggleButton: ToggleButton) {
        let index = toggleButton.tag
        let alarm = AlarmManager.sharedInstance.alarms[index]
        if (toggleButton.state) {
            // TODO: check date & time
            AlarmManager.sharedInstance.unsetAlarm(alarm.uid!, cb: Callback() { (result, _, _, _) in
                for (_, _) in alarm.repeats!.enumerate() {
                    AlarmManager.sharedInstance.setAlarm(alarm.uid!)
                }
            })
            alarm.on = true
        } else {
            AlarmManager.sharedInstance.unsetAlarm(alarm.uid!)
            alarm.on = false
        }
        AlarmManager.sharedInstance.saveAlarm(alarm)
        self.tableView.reloadData()
    }

    // MARK: - oishinavigationbardelegate
    
    override func menuDidTap() {
        let menu = MenuTableViewController(nibName: "MenuTableViewController", bundle: nil)
        menu.modalPresentationStyle = .OverCurrentContext
        self.definesPresentationContext = true
        self.presentViewController(menu, animated: false, completion: nil)
    }
    
    // MARK: - SWTableViewCell
    
    func leftbuttons() -> NSArray {
        let leftButtons = NSMutableArray()
        leftButtons.sw_addUtilityButtonWithColor(UIColor.redColor(), icon: UIImage(named: "delete_button"))
        return leftButtons
    }
    
    func swipeableTableViewCell(cell: SWTableViewCell!, didTriggerLeftUtilityButtonWithIndex index: Int) {
        if (index == 0) {
            // TODO: - delete alarm
            if (self.isPresentMyList) {
                let alarm = AlarmManager.sharedInstance.alarms[cell.tag]
                AlarmManager.sharedInstance.unsetAlarm(alarm.uid!)
                AlarmManager.sharedInstance.deleteAlarm(alarm.uid!)
                self.tableView.reloadData()
            } else {
                let alarm = AlarmManager.sharedInstance.friendAlarms[cell.tag]
                AlarmManager.sharedInstance.deleteFriendAlarm(alarm.uid!)
                self.tableView.reloadData()
            }
        }
    }
    
    func swipeableTableViewCellShouldHideUtilityButtonsOnSwipe(cell: SWTableViewCell!) -> Bool {
        return true
    }
    
    // MARK: - oishitabbar
    
    override func leftButtonDidTap() {
        self.isPresentMyList = true
        self.tableView.reloadData()
    }
    
    override func rightButtonDidTap() {
        self.isPresentMyList = false
        self.tableView.reloadData()
    }

    // MARK: - duplicate
    
    func getVideoPathString() -> NSURL? {
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentsDirectory: AnyObject = paths[0]
        let dataPath = documentsDirectory.stringByAppendingPathComponent("video")
        
        let fileManager = NSFileManager()
        if (!fileManager.fileExistsAtPath(dataPath)) {
            do {
                try NSFileManager.defaultManager().createDirectoryAtPath(dataPath, withIntermediateDirectories: false, attributes: nil)
            } catch let error as NSError {
                print(error.localizedDescription);
            }
        } else {
            if (fileManager.fileExistsAtPath(dataPath + "/tempVideo.mov")) {
            } else {
            }
        }
        
        return NSURL(string: "file://" + dataPath)
    }
}
