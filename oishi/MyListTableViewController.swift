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
        
        if let no = alarm.actorNo {
            cell.userImageView.image = UIImage(named: "actorc_\(no)")
        }
        
        if let _ = alarm.custom {
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
            // TODO: check date & time
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
        self.presentViewController(menu, animated: false, completion: nil)
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
                print("check")
            } catch let error as NSError {
                print(error.localizedDescription);
            }
        } else {
            print("video path \(dataPath)/tempVideo.mov")
            if (fileManager.fileExistsAtPath(dataPath + "/tempVideo.mov")) {
                print("tempVideo.mov exist")
            } else {
                print("tempVideo.mov not exist")
            }
        }
        
        return NSURL(string: "file://" + dataPath)
    }
}
