//
//  MenuTableViewController.swift
//  oishi
//
//  Created by warinporn khantithamaporn on 8/19/2559 BE.
//  Copyright © 2559 com.rollingneko. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKShareKit
import SwiftyJSON
import SwiftKeychainWrapper

class MenuTableViewController: OishiTableViewController, MenuTableViewCellDelegate, FBSDKSharingDelegate {
    
    var bottomGreenTeaImageView: UIImageView = UIImageView()
    
    var popup: PopupThankyouView?
    
    let menu: [String] = ["สร้างการเตือน", "รายการตั้งเตือน", "วิธีการเล่น", "แกลลอรี่", "แชร์"]
    
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
        self.tableView.backgroundColor = UIColor(hexString: "162915")?.colorWithAlphaComponent(0.95)
        
        self.view.clipsToBounds = true
        self.tableView.clipsToBounds = true
        
        self.tableView.registerNib(UINib(nibName: "MenuTableViewCell", bundle: nil), forCellReuseIdentifier: "menuCell")
        
        self.navBar.menuImageView.image = UIImage(named: "close")
        
        self.backgroundImageView.image = nil
        self.backgroundImageView.backgroundColor = UIColor.clearColor()
        
        self.showBottomBarView = false
        
        let bottomGreenTeaSize = CGSizeMake(Otification.calculatedWidthFromRatio(587.0), Otification.calculatedHeightFromRatio(298.0))
        self.bottomGreenTeaImageView.frame = CGRectMake(self.screenSize.width - bottomGreenTeaSize.width, self.screenSize.height - bottomGreenTeaSize.height, bottomGreenTeaSize.width, bottomGreenTeaSize.height)
        self.bottomGreenTeaImageView.image = UIImage(named: "menu_greentea")
        self.bottomGreenTeaImageView.layer.zPosition = 1000
        
        // self.view.addSubview(bottomGreenTeaImageView)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.view.frame = CGRectMake(0.0, 0.0, Otification.rWidth, Otification.rHeight)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func menuDidTap() {
        self.popup?.removeFromSuperview()
        self.dismissViewControllerAnimated(false, completion: nil)
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menu.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("menuCell", forIndexPath: indexPath) as! MenuTableViewCell
        cell.initMenuCell(indexPath.row == self.menu.count - 1, title: self.menu[indexPath.row])
        if (indexPath.row == self.menu.count - 1) {
            cell.initShareButtons()
            cell.delegate = self
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.dismissViewControllerAnimated(false, completion: nil)
        if (indexPath.row == 0) {
            OtificationGoogleAnalytics.sharedInstance.sendGoogleAnalyticsEventTracking(.Button, action: .Clicked, label: "bnt_create")
            if !(self.presentingViewController is CreateAlarmTableViewController) {
                ViewControllerManager.sharedInstance.presentCreateAlarm()
            }
        } else if (indexPath.row == 1) {
            OtificationGoogleAnalytics.sharedInstance.sendGoogleAnalyticsEventTracking(.Button, action: .Clicked, label: "bnt_list")
            if !(self.presentingViewController is MyListTableViewController) {
                ViewControllerManager.sharedInstance.presentMyList()
            }
        } else if (indexPath.row == 2) {
            OtificationGoogleAnalytics.sharedInstance.sendGoogleAnalyticsEventTracking(.Button, action: .Clicked, label: "bnt_howto")
            if !(self.presentingViewController is TutorialViewController) {
                ViewControllerManager.sharedInstance.presentTutorial()
            }
        } else if (indexPath.row == 3) {
            OtificationGoogleAnalytics.sharedInstance.sendGoogleAnalyticsEventTracking(.Button, action: .Clicked, label: "bnt_gallery")
            if !(self.presentingViewController is GalleryTableViewController) {
                ViewControllerManager.sharedInstance.presentGallery()
            }
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return Otification.calculatedHeightFromRatio(234.0)
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView(frame: CGRectZero)
    }
   
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Otification.calculatedHeightFromRatio(322.0)
    }
    
    func shareFBDidTap() {
        OtificationGoogleAnalytics.sharedInstance.sendGoogleAnalyticsEventTracking(.Button, action: .Clicked, label: "bnt_main_share-FB")
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
        let contentImg = NSURL(string: DataManager.sharedInstance.getObjectForKey("share_image") as! String)
        let contentURL = NSURL(string: DataManager.sharedInstance.getObjectForKey("share_url") as! String)
        let contentTitle = DataManager.sharedInstance.getObjectForKey("share_title") as! String
        let contentDescription = DataManager.sharedInstance.getObjectForKey("share_description") as! String
        
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
        if let _ = results["postId"] {
            OtificationHTTPService.sharedInstance.saveFBShare(results["postId"] as! String)
            OtificationHTTPService.sharedInstance.shareResult()
            self.popup = PopupThankyouView(frame: CGRectMake(0.0, 0.0, Otification.rWidth, Otification.rHeight))
            popup?.isOnlyThankyou = true
            popup?.initPopupView()
            self.view.addSubview(popup!)
        }
    }
    
    func shareLineDidTap() {
        OtificationGoogleAnalytics.sharedInstance.sendGoogleAnalyticsEventTracking(.Button, action: .Clicked, label: "bnt_main_share-line")
        if let shareUrlString = DataManager.sharedInstance.getObjectForKey("share_url") {
            let lineUrl = NSURL(string: "line://msg/text/\(shareUrlString)")
            if (UIApplication.sharedApplication().canOpenURL(lineUrl!)) {
                UIApplication.sharedApplication().openURL(lineUrl!)
                self.popup = PopupThankyouView(frame: CGRectMake(0.0, 0.0, Otification.rWidth, Otification.rHeight))
                popup?.isOnlyThankyou = true
                popup?.initPopupView()
                self.view.addSubview(popup!)
            }
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
