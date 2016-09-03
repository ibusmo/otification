//
//  CreateFriendTableViewController.swift
//  oishi
//
//  Created by warinporn khantithamaporn on 8/23/2559 BE.
//  Copyright © 2559 com.rollingneko. All rights reserved.
//

import UIKit
import MediaPlayer
import FBSDKLoginKit
import FBSDKShareKit
import SwiftyJSON
import SwiftKeychainWrapper

class CreateFriendTableViewController: OishiTableViewController, ActionsTableViewCellDelegate, ActorsPickerTableViewCellDelegate, FBSDKSharingDelegate, PopupThankyouViewDelegate {

    let frontImageView = UIImageView()
    var popup: PopupThankyouView?
    
    let actorNameLabel = UILabel()
    var sendToFriendImageView = UIImageView()
    var facebookButton = UIButton()
    var lineButton = UIButton()
    
    var action: Action = Otification.friendAlarmActions[0]
    var actor: Actor = Otification.actors[0]   
    var selectedActorActive: Bool = true
    
    var selectedActors = [String]()

    var dictionary = Dictionary<String, [ActionInfo]>()
    var selectedActionInfo = [ActionInfo]()
    var selectedActionInfoNo = "1"
    
    var moviePlayer = MPMoviePlayerController()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.tableView.bounces = false
        
        self.tableView.registerNib(UINib(nibName: "FriendActionsTableViewCell", bundle: nil), forCellReuseIdentifier: "friendActionsCell")
        self.tableView.registerNib(UINib(nibName: "FriendActorsPickerTableViewCell", bundle: nil), forCellReuseIdentifier: "friendActorsCell")
        
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        self.showBottomBarView = true
        self.tabBar.setBottomBarView("เตือนตัวเอง", rightButtonTitle: "ส่งให้เพื่อน", leftButtonSelected: false)
        
        self.backgroundImageView.frame = CGRectMake(0.0, 0.0, self.screenSize.width, self.screenSize.height)
        self.backgroundImageView.image = UIImage(named: "createfriend_bg")
        self.backgroundImageView.contentMode = UIViewContentMode.ScaleAspectFill
        
        self.initCreateFriendView()
        
        self.getPlaylistFriend()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CreateAlarmTableViewController.moviePlayerExitFullScreen), name: MPMoviePlayerPlaybackDidFinishNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CreateAlarmTableViewController.moviePlayerExitFullScreen), name: MPMoviePlayerDidExitFullscreenNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initCreateFriendView() {
        self.frontImageView.frame = CGRectMake(0.0, Otification.rHeight - Otification.calculatedHeightFromRatio(905.0), Otification.rWidth, Otification.calculatedHeightFromRatio(905.0))
        self.frontImageView.image = UIImage(named: "createfriend_front_bg")
        self.frontImageView.layer.zPosition = 750
        self.frontImageView.userInteractionEnabled = true
        
        let sendImageSize = CGSizeMake(Otification.calculatedWidthFromRatio(482.0), Otification.calculatedHeightFromRatio(113.0))
        self.sendToFriendImageView.frame = CGRectMake((Otification.rWidth - sendImageSize.width) / 2.0, Otification.calculatedHeightFromRatio(322.0), sendImageSize.width, sendImageSize.height)
        self.sendToFriendImageView.image = UIImage(named: "send_to_friend")
        
        let bubbleSize = CGSizeMake(Otification.calculatedWidthFromRatio(657.0), Otification.calculatedHeightFromRatio(286.0))
        self.actorNameLabel.frame = CGRectMake((Otification.rWidth - bubbleSize.width) / 2.0, Otification.calculatedHeightFromRatio(10.0), bubbleSize.width, bubbleSize.height)
        self.actorNameLabel.font = UIFont(name: Otification.DBHELVETHAICA_X_BOLD, size: Otification.calculatedHeightFromRatio(90.0))
        self.actorNameLabel.textColor = UIColor.blackColor()
        self.actorNameLabel.textAlignment = .Center
        
        self.actorNameLabel.text = "พุฒ พุฒิชัย"
        
        let shareButtonSize = CGSizeMake(Otification.calculatedWidthFromRatio(522.0), Otification.calculatedHeightFromRatio(185.0))
        self.facebookButton.setFrameAndImageWithShadow(CGRectMake(Otification.calculatedWidthFromRatio(86.0), Otification.calculatedHeightFromRatio(466.0), shareButtonSize.width, shareButtonSize.height), image: UIImage(named: "createfriend_fb_button"))
        self.facebookButton.addTarget(self, action: #selector(CreateFriendTableViewController.shareToFacebook), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.lineButton.setFrameAndImageWithShadow(CGRectMake(Otification.calculatedWidthFromRatio(636.0), Otification.calculatedHeightFromRatio(466.0), shareButtonSize.width, shareButtonSize.height), image: UIImage(named: "createfriend_line_button"))
        self.lineButton.addTarget(self, action: #selector(CreateFriendTableViewController.shareToLine), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(self.frontImageView)
        self.frontImageView.addSubview(self.actorNameLabel)
        self.frontImageView.addSubview(self.sendToFriendImageView)
        self.frontImageView.addSubview(self.facebookButton)
        self.frontImageView.addSubview(self.lineButton)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            let cell = tableView.dequeueReusableCellWithIdentifier("friendActionsCell", forIndexPath: indexPath) as! FriendActionsTableViewCell
            cell.isFriendAction = true
            cell.delegate = self
            cell.initSelectedImageView()
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("friendActorsCell", forIndexPath: indexPath) as! FriendActorsPickerTableViewCell
            var active = [Bool](count: 6, repeatedValue: false)
            for (index, actionInfo) in self.selectedActionInfo.enumerate() {
                if let act = actionInfo.active where act == "1" {
                    active[index] = true
                }
            }
            cell.active = active
            cell.delegate = self
            cell.setActors(self.selectedActors)
            cell.carousel.reloadData()
            cell.carousel.scrollToItemAtIndex(0, animated: false)
            return cell
        }
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.row == 0) {
            return Otification.calculatedHeightFromRatio(380.0)
        } else {
            return Otification.calculatedHeightFromRatio(1166.0)
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRectMake(0.0, 0.0, Otification.rWidth, Otification.calculatedHeightFromRatio(144.0)))
        view.backgroundColor = UIColor.clearColor()
        return view
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Otification.calculatedHeightFromRatio(144.0)
    }
    
    // MARK: - actionstableviewcelldelegate
    
    func didSelectAction(action: Action) {
        let labels: [String] = ["hbd", "missu", "gn", "fight", "travel", "sorry", "thnx", "takecare"]
        OtificationGoogleAnalytics.sharedInstance.sendGoogleAnalyticsEventTracking(.Button, action: .Clicked, label: "bnt_f_\(labels[Int(action.action!)! - 1]))")
        self.action = action
        if let actionInfos = self.dictionary[self.action.action!] {
            self.selectedActors.removeAll(keepCapacity: false)
            for actionInfo in actionInfos {
                self.selectedActors.append(actionInfo.actor!)
            }
            self.selectedActionInfo = actionInfos
            
            let actor = Otification.actors[Int(self.selectedActors[0])! - 1]
            self.actorNameLabel.text = actor.actorName
            self.actor = actor
            
            self.tableView.reloadData()
        }
    }
    
    // MARK: - actorstableviewcelldelegate
    
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
                    
                    let videoPreview = VideoPreviewViewController(nibName: "VideoPreviewViewController", bundle: nil)
                    videoPreview.videoUrlString = videoUrlString!
                    self.presentViewController(videoPreview, animated: false, completion: nil)
                    
                    /*
                    self.moviePlayer = MPMoviePlayerController(contentURL: NSURL(string: videoUrlString!))
                    self.moviePlayer.view.frame = CGRectMake(0.0, 0.0, Otification.rWidth, Otification.rHeight)
                    self.view.addSubview(self.moviePlayer.view)
                    self.moviePlayer.fullscreen = true
                    self.moviePlayer.controlStyle = MPMovieControlStyle.Embedded
                     */
                }
            }
        }
    }
    
    // MARK: - api
    
    func getPlaylistFriend() {
        let _ = OtificationHTTPService.sharedInstance.getPlaylistFriend(Callback() { (response, success, errorString, error) in
            if let dictionary = response where success {
                self.dictionary = dictionary
                if (self.selectedActionInfo.count > 0) {
                    self.selectedActionInfoNo = self.selectedActionInfo[0].no!
                }
                if let actionInfos = self.dictionary[self.selectedActionInfoNo] {
                    for actionInfo in actionInfos {
                        self.selectedActors.append(actionInfo.actor!)
                    }
                    self.selectedActionInfo = actionInfos
                    self.tableView.reloadData()
                }
            }
        })
    }
    
    // MARK: - mpmovieplayer
    
    func moviePlayerExitFullScreen() {
        self.moviePlayer.stop()
        self.moviePlayer.view.removeFromSuperview()
    }
    
    // MARK: - oishitabbardelegate
    
    override func leftButtonDidTap() {
        OtificationGoogleAnalytics.sharedInstance.sendGoogleAnalyticsEventTracking(.Button, action: .Clicked, label: "bnt_myself")
        ViewControllerManager.sharedInstance.presentCreateAlarm()
    }
    
    // MARK: - oishinavigationbardelegate
    
    override func menuDidTap() {
        self.popup?.removeFromSuperview()
        let menu = MenuTableViewController(nibName: "MenuTableViewController", bundle: nil)
        menu.modalPresentationStyle = .OverCurrentContext
        self.definesPresentationContext = true
        self.presentViewController(menu, animated: false, completion: nil)
    }
    
    // MARK: - share to facebook
    
    func shareToFacebook() {
        OtificationGoogleAnalytics.sharedInstance.sendGoogleAnalyticsEventTracking(.Button, action: .Clicked, label: "bnt_f_fb")
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
                            
                            OtificationHTTPService.sharedInstance.updateFacebookIDNonToken(KeychainWrapper.defaultKeychainWrapper().stringForKey("fbuid")!)
                            
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
        OtificationHTTPService.sharedInstance.saveFBShare(results["postId"] as! String)
        OtificationHTTPService.sharedInstance.shareResult()
        // save friend alarm
        self.popup = PopupThankyouView(frame: CGRectMake(0.0, 0.0, Otification.rWidth, Otification.rHeight))
        popup?.isOnlyThankyou = true
        popup?.initPopupView()
        popup?.delegate = self
        self.view.addSubview(popup!)
        
        for (_, actionInfo) in self.selectedActionInfo.enumerate() {
            if let act = actionInfo.actor where act == actor.name {
                AlarmManager.sharedInstance.saveFriendAlarm(Otification.friendAlarmActions[Int(actionInfo.no!)! - 1].actionName!, actorNo: actionInfo.actor!)
            }
        }
    }
    
    // MARK: - share to line
    
    func shareToLine() {
        OtificationGoogleAnalytics.sharedInstance.sendGoogleAnalyticsEventTracking(.Button, action: .Clicked, label: "bnt_f_line")
        for (_, actionInfo) in self.selectedActionInfo.enumerate() {
            if let act = actionInfo.actor where act == actor.name {
                // save friend alarm
                let shareUrl = actionInfo.shareUrl
                let lineUrl = NSURL(string: "line://msg/text/\(shareUrl!)")
                if (UIApplication.sharedApplication().canOpenURL(lineUrl!)) {
                    UIApplication.sharedApplication().openURL(lineUrl!)
                    self.popup = PopupThankyouView(frame: CGRectMake(0.0, 0.0, Otification.rWidth, Otification.rHeight))
                    popup?.isOnlyThankyou = true
                    popup?.initPopupView()
                    popup?.delegate = self
                    self.view.addSubview(popup!)
                    
                    AlarmManager.sharedInstance.saveFriendAlarm(Otification.friendAlarmActions[Int(actionInfo.no!)! - 1].actionName!, actorNo: actionInfo.actor!)
                }
            }
        }
    }
    
    // MARK: - save friend alarm
    
    // MARK: - popupthankyouviewdelegate
    
    func popupDidRemoveFromSuperview() {
        ViewControllerManager.sharedInstance.presentMyList(false)
    }

}
