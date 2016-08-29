//
//  GalleryTableViewController.swift
//  oishi
//
//  Created by warinporn khantithamaporn on 8/27/2559 BE.
//  Copyright © 2559 com.rollingneko. All rights reserved.
//

import UIKit
import MediaPlayer
import FBSDKLoginKit
import FBSDKShareKit
import SwiftyJSON

class GalleryTableViewController: OishiTableViewController, ActorsPickerTableViewCellDelegate, VideoPreviewTableViewCellDelegate, FBSDKSharingDelegate, PopupThankyouViewDelegate {
    
    var popupView: PopupView?
    
    var actorsPickerView = GalleryActorsPickerView(frame: CGRectZero)
    let actorNameLabel = UILabel()
    var popup: PopupThankyouView?
    
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

        // Do any additional setup after loading the view.
        self.tableView.backgroundColor = UIColor.clearColor()
        self.view.backgroundColor = UIColor.clearColor()
        
        self.backgroundImageView.frame = CGRectMake(0.0, 0.0, Otification.rWidth, Otification.rHeight)
        self.backgroundImageView.image = UIImage(named: "gallery_bg")
        self.backgroundImageView.contentMode = UIViewContentMode.ScaleAspectFill
        
        self.tableView.registerNib(UINib(nibName: "VideoPreviewTableViewCell", bundle: nil), forCellReuseIdentifier: "videoPreviewCell")
        self.tableView.bounces = false
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        self.showBottomBarView = false
        
        self.view.addSubview(self.actorsPickerView)
        
        self.actorsPickerView.delegate = self
        
        let bubbleSize = CGSizeMake(Otification.calculatedWidthFromRatio(607.0), Otification.calculatedHeightFromRatio(286.0))
        self.actorNameLabel.frame = CGRectMake(((Otification.rWidth - bubbleSize.width) / 2.0) - Otification.calculatedWidthFromRatio(20.0), Otification.calculatedHeightFromRatio(800.0), bubbleSize.width, bubbleSize.height)
        self.actorNameLabel.font = UIFont(name: Otification.DBHELVETHAICA_X_BOLD, size: Otification.calculatedHeightFromRatio(80.0))
        self.actorNameLabel.textColor = UIColor.blackColor()
        self.actorNameLabel.textAlignment = .Center
        
        self.actorNameLabel.text = "พุฒ พุฒิชัย"
        
        self.view.addSubview(self.actorNameLabel)
        
        self.getPlaylistGallery()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // y = 1122
        self.tableView.frame = CGRectMake(0.0, Otification.calculatedHeightFromRatio(1060.0), self.tableView.frame.size.width, Otification.rHeight - Otification.calculatedHeightFromRatio(1080.0))
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CreateAlarmTableViewController.moviePlayerExitFullScreen), name: MPMoviePlayerPlaybackDidFinishNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CreateAlarmTableViewController.moviePlayerExitFullScreen), name: MPMoviePlayerDidExitFullscreenNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: MPMoviePlayerWillExitFullscreenNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: MPMoviePlayerPlaybackDidFinishNotification, object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        self.tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, Otification.calculatedHeightFromRatio(100.0), 0.0)
        self.tableView.setNeedsDisplay()
    }
    
    override func viewWillLayoutSubviews() {
        // self.tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, Otification.calculatedHeightFromRatio(40.0), 0.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.selectedActionInfo.count % 2 == 1 ? (self.selectedActionInfo.count / 2) + 1 : self.selectedActionInfo.count / 2
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("videoPreviewCell", forIndexPath: indexPath) as! VideoPreviewTableViewCell
        
        cell.initVideoPreviewCell()
        cell.index = indexPath.row
        cell.delegate = self
        
        cell.leftVideoPreviewView.removeFromSuperview()
        cell.rightVideoPreviewView.removeFromSuperview()
        
        let leftActionInfo = self.selectedActionInfo[indexPath.row * 2]
        cell.initLeftVideoPreview(leftActionInfo)
        
        if ((indexPath.row * 2) + 1 < self.selectedActionInfo.count) {
            let rightActionInfo = self.selectedActionInfo[(indexPath.row * 2) + 1]
            cell.initRightVideoPreview(rightActionInfo)
        }
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return Otification.calculatedHeightFromRatio(560.0)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    // MARK: - videopreviewtableviewcelldelegate
    
    func didSelectVideoPreviewAtIndex(index: Int) {
        let actionInfo = self.selectedActionInfo[index]
        let videoUrlString = actionInfo.videoUrlString
        let videoPreview = VideoPreviewViewController(nibName: "VideoPreviewViewController", bundle: nil)
        videoPreview.videoUrlString = videoUrlString!
        self.presentViewController(videoPreview, animated: false, completion: nil)
    }
    
    func didTapLINEAtIndex(index: Int) {
        let actionInfo = self.selectedActionInfo[index]
        let shareUrl = actionInfo.shareUrl
        let lineUrl = NSURL(string: "line://msg/text/\(shareUrl!)")
        if (UIApplication.sharedApplication().canOpenURL(lineUrl!)) {
            UIApplication.sharedApplication().openURL(lineUrl!)
            self.popup = PopupThankyouView(frame: CGRectMake(0.0, 0.0, Otification.rWidth, Otification.rHeight))
            popup?.isOnlyThankyou = true
            popup?.initPopupView()
            self.view.addSubview(popup!)
        }
    }
    
    // MARK: - api
    
    func getPlaylistGallery() {
        let _ = OtificationHTTPService.sharedInstance.getPlaylistGallery(Callback() { (response, success, errorString, error) in
            if let dictionary = response where success {
                self.dictionary = dictionary
                print("gallery.count: \(self.dictionary.count)")
                if let actionInfos = self.dictionary["1"] {
                    self.selectedActionInfo = actionInfos
                    self.tableView.reloadData()
                }
            }
        })   
    }
    
    // MARK: - actorspickertableviewcelldelegate
    
    func didPickActor(actor: Actor, active: Bool) {
        self.actorNameLabel.text = actor.actorName
        self.actor = actor
        self.selectedActorActive = active
        
        if let actionInfos = self.dictionary[self.actor.name!] {
            self.selectedActionInfo = actionInfos
            self.tableView.reloadData()
        }
    }
    
    func didSelectActor(actor: Actor, active: Bool) {
        /*
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
         */
    }
    
    // MARK: - mpmovieplayer
    
    func moviePlayerExitFullScreen() {
        self.moviePlayer.stop()
        self.moviePlayer.view.removeFromSuperview()
    }
    
    // MARK: - oishinavigationbardelegate
    
    override func menuDidTap() {
        let menu = MenuTableViewController(nibName: "MenuTableViewController", bundle: nil)
        menu.modalPresentationStyle = .OverCurrentContext
        self.definesPresentationContext = true
        self.presentViewController(menu, animated: false, completion: nil)
    }
    
    // MARK: - facebook
    
    func didTapFBAtIndex(index: Int) {
        self.shareToFacebook(index)
    }
    
    func shareToFacebook(index: Int) {
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
                    
                    self.shareFacebookResult(index)
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
                            
                            self.shareFacebookResult(index)
                        }
                    })
                    connection.start()
                }
            })
        }
    }
    
    func shareFacebookResult(index: Int) {
        let actionInfo = self.selectedActionInfo[index]
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
    
    func sharerDidCancel(sharer: FBSDKSharing!) {
        print("didCancel")
    }
    
    func sharer(sharer: FBSDKSharing!, didFailWithError error: NSError!) {
        print("didFailWithError: \(error.localizedDescription)")
    }
    
    func sharer(sharer: FBSDKSharing!, didCompleteWithResults results: [NSObject : AnyObject]!) {
        print("didCompleteWithResults")
        self.popup = PopupThankyouView(frame: CGRectMake(0.0, 0.0, Otification.rWidth, Otification.rHeight))
        popup?.isOnlyThankyou = true
        popup?.initPopupView()
        self.view.addSubview(popup!)
    }
    
    /*
    func popupDidRemoveFromSuperview() {
        if (Reachability.isConnectedToNetwork()) {
            self.getPlaylistGallery()
        } else {
            // TODO: - popup
            UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                }, completion: { finished in
                self.popupView = PopupView(frame: CGRectMake(0.0, 0.0, Otification.rWidth, Otification.rHeight))
                self.popupView?.initPopupView("กรุณาตรวจสอบสัญญาณอินเทอร์เน็ต")
                self.popupView?.delegate = self
                self.view.addSubview(self.popupView!)
            })
        }
    }
     */

}
