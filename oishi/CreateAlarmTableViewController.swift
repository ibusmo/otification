//
//  CreateAlarmTableViewController.swift
//  oishi
//
//  Created by warinporn khantithamaporn on 8/17/2559 BE.
//  Copyright © 2559 com.rollingneko. All rights reserved.
//

import UIKit
import MediaPlayer

class CreateAlarmTableViewController: OishiTableViewController, TimePickerTableViewCellDelegate, ActionsTableViewCellDelegate, ActorsPickerTableViewCellDelegate, DownloadViewControllerDelegate {
    
    let frontImageView = UIImageView()
    
    let actorNameLabel = UILabel()
    let bubbleImageView = UIImageView()
    
    let saveButton = UIButton()
    let customLabel = UIImageView()
    let customButton = UIButton()
    
    var hour: Int?
    var minute: Int?
    var action: Action = Otification.selfAlarmActions[0]
    var actor: Actor = Otification.actors[0]
    var selectedActorActive: Bool = true
    
    var dictionary = Dictionary<String, [ActionInfo]>()
    var selectedActionInfo = [ActionInfo]()
    
    var moviePlayer = MPMoviePlayerController()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.getPlaylist()
        
        self.tableView.bounces = false
        
        self.tableView.registerNib(UINib(nibName: "TimePickerTableViewCell", bundle: nil), forCellReuseIdentifier: "timePickerCell")
        self.tableView.registerNib(UINib(nibName: "ActionsTableViewCell", bundle: nil), forCellReuseIdentifier: "actionsCell")
        self.tableView.registerNib(UINib(nibName: "ActorsPickerTableViewCell", bundle: nil), forCellReuseIdentifier: "actorsCell")
        
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        self.showBottomBarView = true
        self.tabBar.setBottomBarView("เตือนตัวเอง", rightButtonTitle: "ส่งให้เพื่อน", leftButtonSelected: true)
        
        self.backgroundImageView.frame = CGRectMake(0.0, 0.0, self.screenSize.width, self.screenSize.height)
        self.backgroundImageView.image = UIImage(named: "createalarm_bg")
        self.backgroundImageView.contentMode = UIViewContentMode.ScaleAspectFill
        
        self.initCreateAlarmViews()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CreateAlarmTableViewController.moviePlayerExitFullScreen), name: MPMoviePlayerPlaybackDidFinishNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CreateAlarmTableViewController.moviePlayerExitFullScreen), name: MPMoviePlayerDidExitFullscreenNotification, object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func moviePlayerExitFullScreen() {
        print("check")
        self.moviePlayer.stop()
        self.moviePlayer.view.removeFromSuperview()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: MPMoviePlayerWillExitFullscreenNotification, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initCreateAlarmViews() {
        self.frontImageView.frame = CGRectMake(0.0, Otification.rHeight - Otification.calculatedHeightFromRatio(692.0), Otification.rWidth, Otification.calculatedHeightFromRatio(692.0))
        self.frontImageView.image = UIImage(named: "createalarm_front_bg")
        self.frontImageView.layer.zPosition = 750
        self.frontImageView.userInteractionEnabled = true
        
        let saveButtonSize = CGSizeMake(Otification.calculatedWidthFromRatio(625.0), Otification.calculatedHeightFromRatio(215.0))
        self.saveButton.setFrameAndImageWithShadow(CGRectMake((self.backgroundImageView.frame.size.width - saveButtonSize.width) / 2.0, Otification.calculatedHeightFromRatio(272.0), saveButtonSize.width, saveButtonSize.height), image: (UIImage(named: "save_button")))
        self.saveButton.layer.zPosition = 751
        self.saveButton.addTarget(self, action: #selector(CreateAlarmTableViewController.saveNewAlarm), forControlEvents: UIControlEvents.TouchUpInside)
        
        let customLabelSize = CGSizeMake(Otification.calculatedWidthFromRatio(256.0), Otification.calculatedHeightFromRatio(37.0))
        self.customLabel.frame = CGRectMake(Otification.calculatedWidthFromRatio(41.0), self.saveButton.frame.origin.y - Otification.calculatedHeightFromRatio(15.0), customLabelSize.width, customLabelSize.height)
        self.customLabel.image = UIImage(named: "custom_label")
        
        let customButtonSize = CGSizeMake(Otification.calculatedWidthFromRatio(238.0), Otification.calculatedHeightFromRatio(182.0))
        self.customButton.setFrameAndImageWithShadow(CGRectMake(Otification.calculatedWidthFromRatio(54.0), (self.saveButton.frame.origin.y + saveButtonSize.height) - customButtonSize.height, customButtonSize.width, customButtonSize.height), image: UIImage(named: "custom_button"))
        self.customButton.layer.zPosition = 751
        self.customButton.addTarget(self, action: #selector(CreateAlarmTableViewController.customAlarm), forControlEvents: UIControlEvents.TouchUpInside)
        
        // 657x286
        let bubbleSize = CGSizeMake(Otification.calculatedWidthFromRatio(657.0), Otification.calculatedHeightFromRatio(286.0))
        self.bubbleImageView.frame = CGRectMake((Otification.rWidth - bubbleSize.width) / 2.0, Otification.calculatedHeightFromRatio(12.0), bubbleSize.width, bubbleSize.height)
        self.bubbleImageView.image = UIImage(named: "bubble")
        
        self.actorNameLabel.frame = CGRectMake(((Otification.rWidth - bubbleSize.width) / 2.0) - Otification.calculatedWidthFromRatio(6.0), Otification.calculatedHeightFromRatio(4.0), bubbleSize.width, bubbleSize.height)
        self.actorNameLabel.font = UIFont(name: Otification.DBHELVETHAICA_X_BOLD, size: Otification.calculatedHeightFromRatio(90.0))
        self.actorNameLabel.textColor = UIColor.blackColor()
        self.actorNameLabel.textAlignment = .Center
        
        self.actorNameLabel.text = "พุฒ พุฒิชัย"
        
        self.view.addSubview(self.frontImageView)
        self.frontImageView.addSubview(self.bubbleImageView)
        self.frontImageView.addSubview(self.actorNameLabel)
        self.frontImageView.addSubview(self.saveButton)
        self.frontImageView.addSubview(self.customLabel)
        self.frontImageView.addSubview(self.customButton)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            let cell = tableView.dequeueReusableCellWithIdentifier("timePickerCell", forIndexPath: indexPath) as! TimePickerTableViewCell
            cell.delegate = self
            return cell
        } else if (indexPath.row == 1) {
            let cell = tableView.dequeueReusableCellWithIdentifier("actionsCell", forIndexPath: indexPath) as! ActionsTableViewCell
            cell.delegate = self
            cell.initSelectedImageView()
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("actorsCell", forIndexPath: indexPath) as! ActorsPickerTableViewCell
            var active = [Bool](count: 6, repeatedValue: false)
            for (index, actionInfo) in self.selectedActionInfo.enumerate() {
                if let act = actionInfo.active where act == "1" {
                    active[index] = true
                }
            }
            cell.active = active
            cell.delegate = self
            cell.carousel.reloadData()
            return cell
        }
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.row == 0) {
            return Otification.calculatedHeightFromRatio(568.0)
        } else if (indexPath.row == 1) {
            return Otification.calculatedHeightFromRatio(380.0)
        } else {
            return Otification.calculatedHeightFromRatio(587.0)
        }
    }
    
    // MARK: - timepickertableviewcelldelegate
    
    func didSelectHour(hour: Int) {
        self.hour = hour
    }
    
    func didSelectMinute(minute: Int) {
        self.minute = minute
    }
    
    // MARK: - actorspickertableviewcelldelegate
    
    func didSelectAction(action: Action) {
        self.action = action
        if let actionInfos = self.dictionary[self.action.action!] {
            self.selectedActionInfo = actionInfos
            self.tableView.reloadData()
        }
    }
    
    // MARK: - actorspickertableviewcelldelegate
    
    func didPickActor(actor: Actor, active: Bool) {
        self.actorNameLabel.text = actor.actorName
        self.actor = actor
        self.selectedActorActive = active
    }
    
    func didSelectActor(actor: Actor, active: Bool) {
        if (active) {
            for (_, actionInfo) in self.selectedActionInfo.enumerate() {
                if let act = actionInfo.actor where act == actor.name {
                    let videoUrlString = actionInfo.videoUrlString
                    self.moviePlayer = MPMoviePlayerController(contentURL: NSURL(string: videoUrlString!))
                    self.moviePlayer.view.frame = CGRectMake(0.0, 0.0, Otification.rWidth, Otification.rHeight)
                    self.view.addSubview(self.moviePlayer.view)
                    self.moviePlayer.fullscreen = true
                    self.moviePlayer.controlStyle = MPMovieControlStyle.Embedded
                }
            }
        }
    }
    
    // MARK: - savebuttondidtap
    
    func saveNewAlarm() {
        if let h = self.hour, m = self.minute where self.selectedActorActive {
            // TODO: download vdo & sound first
            
            for (_, actionInfo) in self.selectedActionInfo.enumerate() {
                if let actor = actionInfo.actor where actor == self.actor.name {
                    let videoUrlString = actionInfo.videoUrlString
                    let vSplitedString = videoUrlString!.characters.split{$0 == "/"}.map(String.init)
                    let videoFileName = vSplitedString[vSplitedString.count - 1]
                    
                    let audioUrlString = actionInfo.audioUrlString
                    let aSplitedString = audioUrlString!.characters.split{$0 == "/"}.map(String.init)
                    let audioFileName = aSplitedString[aSplitedString.count - 1]
                    
                    print("vidoeFileName: \(videoFileName)")
                    print("audioFileName: \(audioFileName)")
                    
                    if (!(self.isFileDownloaded(self.getVideoFilePath(videoFileName)) && self.isFileDownloaded(self.getSoundFilePath(audioFileName)))) {
                        let download = DownloadViewController(nibName: "DownloadViewController", bundle: nil)
                        download.modalPresentationStyle = .OverCurrentContext
                        
                        download.videoUrlString = videoUrlString
                        download.audioUrlString = audioUrlString
                        download.delegate = self
                        
                        self.definesPresentationContext = true
                        self.presentViewController(download, animated: true, completion: nil)
                    } else {
                        AlarmManager.sharedInstance.prepareNewAlarm(self.action.actionName!, hour: h, minute: m)
                        AlarmManager.sharedInstance.unsaveAlarm?.soundFileName = audioFileName
                        AlarmManager.sharedInstance.unsaveAlarm?.vdoFileName = videoFileName
                        print("saveAlarmSuccess: \(AlarmManager.sharedInstance.saveAlarm())")
                        ViewControllerManager.sharedInstance.presentMyList()
                    }
                }
            }
            
        } else {
            print("failSaveNewAlarm")
        }
    }
    
    // MARK: - custombuttondidtap
    
    func customAlarm() {
        if let h = self.hour, m = self.minute {
            AlarmManager.sharedInstance.prepareNewAlarm(self.action.actionName!, hour: h, minute: m)
            ViewControllerManager.sharedInstance.presentCustomAlarm()
        }
    }
    
    // MARK: - downloadviewcontrollerdelegate
    
    func finishedDownloadResources() {
        if let h = self.hour, m = self.minute where self.selectedActorActive {
            for (_, actionInfo) in self.selectedActionInfo.enumerate() {
                if let actor = actionInfo.actor where actor == self.actor.name {
                    let videoUrlString = actionInfo.videoUrlString
                    let vSplitedString = videoUrlString!.characters.split{$0 == "/"}.map(String.init)
                    let videoFileName = vSplitedString[vSplitedString.count - 1]
                    
                    let audioUrlString = actionInfo.audioUrlString
                    let aSplitedString = audioUrlString!.characters.split{$0 == "/"}.map(String.init)
                    let audioFileName = aSplitedString[aSplitedString.count - 1]
                    
                    AlarmManager.sharedInstance.prepareNewAlarm(self.action.actionName!, hour: h, minute: m)
                    AlarmManager.sharedInstance.unsaveAlarm?.soundFileName = audioFileName
                    AlarmManager.sharedInstance.unsaveAlarm?.vdoFileName = videoFileName
                    print("saveAlarmSuccess: \(AlarmManager.sharedInstance.saveAlarm())")
                    ViewControllerManager.sharedInstance.presentMyList()
                }
            }
        }
    }
    
    func failedDownloadResources() {
    }
    
    func didCancelDownloadResources() {
    }
    
    // MARK: - oishinavigationbardelegate
    
    override func menuDidTap() {
        let menu = MenuTableViewController(nibName: "MenuTableViewController", bundle: nil)
        menu.modalPresentationStyle = .OverCurrentContext
        self.definesPresentationContext = true
        self.presentViewController(menu, animated: true, completion: nil)
    }
    
    // MARK: - oishitabbardelegate
    
    override func rightButtonDidTap() {
        ViewControllerManager.sharedInstance.presentCreateFriend()
    }
    
    // MARK: - api
    
    func getPlaylist() {
        let _ = OtificationHTTPService.sharedInstance.getPlaylist(Callback() { (response, success, errorString, error) in
            if let dictionary = response where success {
                self.dictionary = dictionary
                if let actionInfos = self.dictionary["1"] {
                    self.selectedActionInfo = actionInfos
                    self.tableView.reloadData()
                }
            }
        })
    }
    
    // MARK: - files
    
    func getVideoFilePath(fileName: String) -> String {
        let libraryPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let soundsPath = libraryPath + "/video"
        let filePath: String = soundsPath + "/\(fileName)"
        
        let fileManager = NSFileManager.defaultManager()
        do {
            if (!fileManager.fileExistsAtPath(soundsPath)) {
                try fileManager.createDirectoryAtPath(soundsPath, withIntermediateDirectories: false, attributes: nil)
            }
        } catch let error1 as NSError {
            print("error" + error1.description)
        }
        
        return filePath
    }
    
    func getSoundFilePath(fileName: String) -> String {
        let libraryPath = NSSearchPathForDirectoriesInDomains(.LibraryDirectory, .UserDomainMask, true)[0]
        let soundsPath = libraryPath + "/Sounds"
        let filePath: String = soundsPath + "/\(fileName)"
        
        let fileManager = NSFileManager.defaultManager()
        do {
            if (!fileManager.fileExistsAtPath(soundsPath)) {
                try fileManager.createDirectoryAtPath(soundsPath, withIntermediateDirectories: false, attributes: nil)
            }
        } catch let error1 as NSError {
            print("error" + error1.description)
        }
        
        return filePath
    }
    
    func isFileDownloaded(path: String) -> Bool {
        let fileManager = NSFileManager.defaultManager()
        if (fileManager.fileExistsAtPath(path)) {
            return true
        } else {
            return false
        }
    }

}
