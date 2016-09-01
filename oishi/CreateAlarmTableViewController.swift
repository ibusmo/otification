//
//  CreateAlarmTableViewController.swift
//  oishi
//
//  Created by warinporn khantithamaporn on 8/17/2559 BE.
//  Copyright © 2559 com.rollingneko. All rights reserved.
//

import UIKit
import MediaPlayer
import FBSDKLoginKit
import FBSDKShareKit
import SwiftyJSON

class CreateAlarmTableViewController: OishiTableViewController, TimePickerTableViewCellDelegate, ActionsTableViewCellDelegate, ActorsPickerTableViewCellDelegate, DownloadViewControllerDelegate, PopupThankyouViewDelegate, FBSDKSharingDelegate {
    
    let frontImageView = UIImageView()
    
    let actorNameLabel = UILabel()
    let bubbleImageView = UIImageView()
    
    let saveButton = UIButton()
    let customLabel = UIImageView()
    let customButton = UIButton()
    
    var popup: PopupThankyouView?
    var popupView: PopupView?
    var download: DownloadViewController?
    
    var hour: Int?
    var minute: Int?
    var action: Action = Otification.selfAlarmActions[0]
    var actor: Actor = Otification.actors[0]
    var selectedActorActive: Bool = true
    
    var dictionary = Dictionary<String, [ActionInfo]>()
    var selectedActionInfo = [ActionInfo]()
    var selectedActionInfoNo = "1"
    
    var isLoadingDataFromAPI = false
    
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
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if (!self.isLoadingDataFromAPI) {
            self.getPlaylist()
        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CreateAlarmTableViewController.moviePlayerExitFullScreen), name: MPMoviePlayerPlaybackDidFinishNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CreateAlarmTableViewController.moviePlayerExitFullScreen), name: MPMoviePlayerDidExitFullscreenNotification, object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        OtificationGoogleAnalytics.sharedInstance.sendGoogleAnalyticsEventTracking(.Page, action: .Opened, label: "page_create")
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: MPMoviePlayerWillExitFullscreenNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: MPMoviePlayerPlaybackDidFinishNotification, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initCreateAlarmViews() {
        self.frontImageView.frame = CGRectMake(0.0, Otification.rHeight - Otification.calculatedHeightFromRatio(692.0), Otification.rWidth, Otification.calculatedHeightFromRatio(683.0))
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
        print("didSelectAction: \(action.action) \(action.actionName)")
        self.action = action
        let labels: [String] = ["GN", "Ex", "read", "wakeup", "appointment"]
        OtificationGoogleAnalytics.sharedInstance.sendGoogleAnalyticsEventTracking(.Button, action: .Clicked, label: "my_\(labels[Int(action.action!)! - 1]))")
        // print("my_\(labels[Int(action.action!)!]))")
        if let actionInfos = self.dictionary[self.action.action!] {
            self.selectedActionInfo.removeAll()
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
            print(self.selectedActionInfo[0].videoUrlString)
            for (_, actionInfo) in self.selectedActionInfo.enumerate() {
                if let act = actionInfo.actor where act == actor.name {
                    let videoUrlString = actionInfo.videoUrlString
                    let videoPreview = VideoPreviewViewController(nibName: "VideoPreviewViewController", bundle: nil)
                    videoPreview.videoUrlString = videoUrlString!
                    self.presentViewController(videoPreview, animated: false, completion: nil)
                }
            }
        }
    }
    
    // MARK: - savebuttondidtap
    
    func saveNewAlarm() {
        OtificationGoogleAnalytics.sharedInstance.sendGoogleAnalyticsEventTracking(.Button, action: .Clicked, label: "my_bnt_save")
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
                    
                    let notiTitle = actionInfo.notiTitle
                    let notiMessage = actionInfo.notiMessage
                    
                    print("vidoeFileName: \(videoFileName)")
                    print("audioFileName: \(audioFileName)")
                    
                    if (!(self.isFileDownloaded(self.getVideoFilePath(videoFileName)) && self.isFileDownloaded(self.getSoundFilePath(audioFileName)))) {
                        // let download = DownloadViewController(nibName: "DownloadViewController", bundle: nil)
                        if (AlarmManager.sharedInstance.alarms.count < 7) {
                            self.download = DownloadViewController()
                            self.download!.modalPresentationStyle = .OverCurrentContext
                            
                            self.download!.videoUrlString = videoUrlString
                            self.download!.audioUrlString = audioUrlString
                            self.download!.delegate = self
                            
                            self.definesPresentationContext = true
                            self.presentViewController(self.download!, animated: false, completion: nil)
                        } else {
                            
                        }
                    } else {
                        AlarmManager.sharedInstance.prepareNewAlarm(self.action.actionName!, hour: h, minute: m)
                        AlarmManager.sharedInstance.unsaveAlarm?.custom = false
                        AlarmManager.sharedInstance.unsaveAlarm?.actorNo = self.actor.name
                        AlarmManager.sharedInstance.unsaveAlarm?.notiTitle = notiTitle
                        AlarmManager.sharedInstance.unsaveAlarm?.notiMessage = notiMessage
                        AlarmManager.sharedInstance.unsaveAlarm?.soundFileName = audioFileName
                        AlarmManager.sharedInstance.unsaveAlarm?.vdoFileName = videoFileName
                        if (AlarmManager.sharedInstance.saveAlarm()) {
                            // present popup here
                            self.popup = PopupThankyouView(frame: CGRectMake(0.0, 0.0, Otification.rWidth, Otification.rHeight))
                            popup?.isOnlyThankyou = false
                            popup?.initPopupView()
                            popup?.delegate = self
                            self.view.addSubview(popup!)
                        } else {
                            // TODO: - exceed maximum alarm (8)
                            self.popupView = PopupView(frame: CGRectMake(0.0, 0.0, Otification.rWidth, Otification.rHeight))
                            self.popupView?.initPopupView("สามารถสร้างการตั้งปลุกได้สูงสุด\n 8 ครั้ง")
                            self.view.addSubview(self.popupView!)
                        }
                    }
                }
            }
            
        } else {
            print("failSaveNewAlarm")
        }
    }
    
    // MARK: - custombuttondidtap
    
    func customAlarm() {
        OtificationGoogleAnalytics.sharedInstance.sendGoogleAnalyticsEventTracking(.Button, action: .Clicked, label: "my_bnt_custom")
        if let h = self.hour, m = self.minute {
            AlarmManager.sharedInstance.prepareNewAlarm(self.action.actionName!, hour: h, minute: m)
            let notiInfo = self.getNotiTitleAndMessageForCustomAlarm()
            AlarmManager.sharedInstance.unsaveAlarm?.notiTitle = notiInfo.0
            AlarmManager.sharedInstance.unsaveAlarm?.notiMessage = notiInfo.1
            ViewControllerManager.sharedInstance.presentCustomAlarm()
        }
    }
    
    // MARK: - downloadviewcontrollerdelegate
    
    func finishedDownloadResources() {
        if let h = self.hour, m = self.minute where self.selectedActorActive {
            for (_, actionInfo) in self.selectedActionInfo.enumerate() {
                if let actor = actionInfo.actor where actor == self.actor.name {
                    
                    self.download?.dismissViewControllerAnimated(false, completion: nil)
                    
                    let videoUrlString = actionInfo.videoUrlString
                    let vSplitedString = videoUrlString!.characters.split{$0 == "/"}.map(String.init)
                    let videoFileName = vSplitedString[vSplitedString.count - 1]
                    
                    let audioUrlString = actionInfo.audioUrlString
                    let aSplitedString = audioUrlString!.characters.split{$0 == "/"}.map(String.init)
                    let audioFileName = aSplitedString[aSplitedString.count - 1]
                    
                    let notiTitle = actionInfo.notiTitle
                    let notiMessage = actionInfo.notiMessage
                    
                    AlarmManager.sharedInstance.prepareNewAlarm(self.action.actionName!, hour: h, minute: m)
                    AlarmManager.sharedInstance.unsaveAlarm?.custom = false
                    AlarmManager.sharedInstance.unsaveAlarm?.actorNo = self.actor.name
                    AlarmManager.sharedInstance.unsaveAlarm?.notiTitle = notiTitle
                    AlarmManager.sharedInstance.unsaveAlarm?.notiMessage = notiMessage
                    AlarmManager.sharedInstance.unsaveAlarm?.soundFileName = audioFileName
                    AlarmManager.sharedInstance.unsaveAlarm?.vdoFileName = videoFileName
                    print("saveAlarmSuccess: \(AlarmManager.sharedInstance.saveAlarm())")
                    
                    self.popup = PopupThankyouView(frame: CGRectMake(0.0, 0.0, Otification.rWidth, Otification.rHeight))
                    popup?.isOnlyThankyou = false
                    popup?.initPopupView()
                    popup?.delegate = self
                    self.view.addSubview(popup!)
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
        OtificationGoogleAnalytics.sharedInstance.sendGoogleAnalyticsEventTracking(.Button, action: .Clicked, label: "bnt_menu")
        self.popup?.removeFromSuperview()
        let menu = MenuTableViewController(nibName: "MenuTableViewController", bundle: nil)
        menu.modalPresentationStyle = .OverCurrentContext
        self.definesPresentationContext = true
        self.presentViewController(menu, animated: false, completion: nil)
    }
    
    // MARK: - oishitabbardelegate
    
    override func leftButtonDidTap() {
    }
    
    override func rightButtonDidTap() {
        ViewControllerManager.sharedInstance.presentCreateFriend()
        OtificationGoogleAnalytics.sharedInstance.sendGoogleAnalyticsEventTracking(.Button, action: .Clicked, label: "bnt_send-f")
    }
    
    // MARK: - mpmovieplayer
    
    func moviePlayerExitFullScreen() {
        self.moviePlayer.stop()
        self.moviePlayer.view.removeFromSuperview()
    }
    
    // MARK: - api
    
    func getPlaylist() {
        self.isLoadingDataFromAPI = true
        let _ = OtificationHTTPService.sharedInstance.getPlaylist(Callback() { (response, success, errorString, error) in
            if let dictionary = response where success {
                self.dictionary.removeAll(keepCapacity: false)
                self.dictionary = dictionary
                if (self.selectedActionInfo.count > 0) {
                    self.selectedActionInfoNo = self.selectedActionInfo[0].no!
                }
                if let actionInfos = self.dictionary[self.selectedActionInfoNo] {
                    self.selectedActionInfo.removeAll()
                    self.selectedActionInfo = actionInfos
                    self.tableView.reloadData()
                }
            }
            self.isLoadingDataFromAPI = false
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
    
    func getNotiTitleAndMessageForCustomAlarm() -> (String, String) {
        switch (self.selectedActionInfoNo) {
            /*
             ตื่น - ถึงเวลาตื่นแล้ว
             ออกกำลังกาย - ถึงเวลาออกกำลังกายแล้ว
             อ่านหนังสือ - ได้เวลาอ่านหนังสือแล้ว
             ฝันดี - ได้เวลานอนแล้ว
             นัด - ถึงเวลานัดแล้ว
            */
            case "1":
                return ("ตื่นนอน", "ถึงเวลาตื่นแล้ว")
            break
            case "2":
                return ("ออกกำลังกาย", "ถึงเวลาออกกำลังกายแล้ว")
            break
            case "3":
                return ("อ่านหนังสือ", "ได้เวลาอ่านหนังสือแล้ว")
            break
            case "4":
                return ("ฝันดี", "ได้เวลานอนแล้ว")
            break
            case "5":
                return ("นัดนู่นนี่นั่น", "ถึงเวลานัดแล้ว")
            break
            default:
                return ("Otification", "It's time to Otification")
            break
        }
        return ("Otification", "It's time to Otification")
    }
    
    // MARK: - popupthankyouviewdelegate
    
    func popupDidRemoveFromSuperview() {
        ViewControllerManager.sharedInstance.presentMyList(true)
    }
    
    func popupFBShareDidTap() {
        if let _ = FBSDKAccessToken.currentAccessToken() {
            let request = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "email,gender,link,first_name,last_name"], HTTPMethod: "GET")
            let connection = FBSDKGraphRequestConnection()
            connection.addRequest(request, completionHandler: { (conn, result, error) -> Void in
                if (error != nil) {
                    print("\(error.localizedDescription)")
                } else {
                    var json = JSON(result)
                    
                    // var params = Dictionary<String, AnyObject>()
                    if let firstname = json["first_name"].string {
                        DataManager.sharedInstance.setObjectForKey(firstname, key: "first_name")
                    }
                    
                    if let lastname = json["last_name"].string {
                        DataManager.sharedInstance.setObjectForKey(lastname, key: "last_name")
                    }
                    
                    if let email = json["email"].string {
                        DataManager.sharedInstance.setObjectForKey(email, key: "email")
                    }
                    
                    if let gender = json["gender"].string {
                        DataManager.sharedInstance.setObjectForKey(gender, key: "gender")
                    }
                    
                    if let link = json["link"].string {
                        DataManager.sharedInstance.setObjectForKey(link, key: "link")
                    }
                    
                    self.shareFacebookResult()
                }
            })
            
            connection.start()
        } else {
            let loginManager = FBSDKLoginManager()
            loginManager.logOut()
            
            loginManager.loginBehavior = FBSDKLoginBehavior.Browser
            
            loginManager.logInWithReadPermissions(["public_profile", "email", "user_about_me"], fromViewController: self, handler: {
                (result: FBSDKLoginManagerLoginResult!, error: NSError?) -> Void in
                if (error != nil) {
                    // fb login error
                } else if (result.isCancelled) {
                    // fb login cancelled
                } else if (result.declinedPermissions.contains("public_profile") || result.declinedPermissions.contains("email") || result.declinedPermissions.contains("user_about_me")) {
                    // declined "public_profile", "email" or "user_about_me"
                } else {
                    // TODO: api to update facebookid-nontoken
                    _ = FBSDKAccessToken.currentAccessToken().userID
                    let request = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "email,gender,link,first_name,last_name"], HTTPMethod: "GET")
                    let connection = FBSDKGraphRequestConnection()
                    connection.addRequest(request, completionHandler: { (conn, result, error) -> Void in
                        if (error != nil) {
                            print("\(error.localizedDescription)")
                        } else {
                            var json = JSON(result)
                            
                            // var params = Dictionary<String, AnyObject>()
                            
                            if let firstname = json["first_name"].string {
                                DataManager.sharedInstance.setObjectForKey(firstname, key: "first_name")
                            }
                            
                            if let lastname = json["last_name"].string {
                                DataManager.sharedInstance.setObjectForKey(lastname, key: "last_name")
                            }
                            
                            if let email = json["email"].string {
                                DataManager.sharedInstance.setObjectForKey(email, key: "email")
                            }
                            
                            if let gender = json["gender"].string {
                                DataManager.sharedInstance.setObjectForKey(gender, key: "gender")
                            }
                            
                            if let link = json["link"].string {
                                DataManager.sharedInstance.setObjectForKey(link, key: "link")
                            }
                            
                            self.shareFacebookResult()
                        }
                    })
                    connection.start()
                }
            })
        }
    }
    
    func shareFacebookResult() {
        for (_, actionInfo) in self.selectedActionInfo.enumerate() {
            if let act = actionInfo.actor where act == actor.name {
                let contentImg = NSURL(string: actionInfo.shareImageUrlString!)
                let contentURL = NSURL(string: actionInfo.shareUrl!)
                let contentTitle = actionInfo.shareTitle!
                let contentDescription = actionInfo.shareDesription!
                
                let photoContent: FBSDKShareLinkContent = FBSDKShareLinkContent()
                
                photoContent.contentURL = contentURL
                photoContent.contentTitle = contentTitle
                photoContent.contentDescription = contentDescription
                photoContent.imageURL = contentImg
                
                let dialog = FBSDKShareDialog()
                dialog.mode = FBSDKShareDialogMode.FeedBrowser
                dialog.shareContent = photoContent
                dialog.delegate = self
                dialog.fromViewController = self
                
                dialog.show()
            }
        }
    }
    
    func sharerDidCancel(sharer: FBSDKSharing!) {
        print("didCancel")
    }
    
    func sharer(sharer: FBSDKSharing!, didFailWithError error: NSError!) {
        print("didFailWithError: \(error.localizedDescription)")
    }
    
    func sharer(sharer: FBSDKSharing!, didCompleteWithResults results: [NSObject : AnyObject]!) {
        print("didCompleteWithResults")
        // save friend alarm
    }
    
    func popupLineShareDidTap() {
        if let _ = self.hour, _ = self.minute where self.selectedActorActive {
            for (_, actionInfo) in self.selectedActionInfo.enumerate() {
                if let actor = actionInfo.actor where actor == self.actor.name {
                    let shareUrl = actionInfo.shareUrl
                    let lineUrl = NSURL(string: "line://msg/text/\(shareUrl!)")
                    if (UIApplication.sharedApplication().canOpenURL(lineUrl!)) {
                        UIApplication.sharedApplication().openURL(lineUrl!)
                    }
                }
            }
        }
    }

}
