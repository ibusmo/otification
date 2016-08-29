//
//  OtificationHTTPService.swift
//  oishi
//
//  Created by warinporn khantithamaporn on 8/22/2559 BE.
//  Copyright © 2559 com.rollingneko. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class OtificationHTTPService {
    
    static let sharedInstance = OtificationHTTPService()
    
    private let BASE_API_URL = "http://www.oishidrink.com/otification/api/mobile/"
    
    private static let APP_DATA_KEY = [
        "appname",
        "show_at_home",
        "active",
        "youtube",
        "share_url",
        "share_title",
        "share_description",
        "share_image",
        "page_howto",
        "api_stat",
        "api_playlist_alarm",
        "api_playlist_friend",
        "api_playlist_gallery",
        "api_save",
        "api_saveNonToken",
        "api_updateFacebook",
        "api_saveUserInfo",
        "api_send"
    ]
    
    private init() {}
    
    func getDataInfo(cb: Callback<Bool>) -> Request {
        let url = self.BASE_API_URL + "getDataInfo.aspx"
        return Alamofire.request(.GET, url).responseJSON { response in
            if let data: AnyObject = response.result.value {
                let json = JSON(data)
                let appData = json["appdata"][0]
                for key in OtificationHTTPService.APP_DATA_KEY {
                    DataManager.sharedInstance.setObjectForKey(appData[key].string, key: key)
                }
                cb.callback(true, true, nil, nil)
            } else {
                cb.callback(nil, false, nil, nil)
            }
        }
    }
    
    func getPlaylist(cb: Callback<[String : [ActionInfo]]>) -> Request {
        let url = self.BASE_API_URL + "getPlaylistAlarm.aspx"
        return Alamofire.request(.GET, url).responseJSON { response in
            if let data: AnyObject = response.result.value {
                let json = JSON(data)
                var dict = Dictionary<String, [ActionInfo]>()
                for (_, group): (String, JSON) in json["playlist"]["group"] {
                    var actionInfos = [ActionInfo]()
                    for (_, list): (String, JSON) in group["list"] {
                        let actionInfo = ActionInfo.getActionInfo(list)
                        actionInfos.append(actionInfo)
                    }
                    dict[group["no"].string!] = actionInfos
                }
                cb.callback(dict, true, nil, nil)
            } else {
                cb.callback(nil, false, nil, nil)
            }
        }
    }
    
    func getPlaylistFriend(cb: Callback<[String : [ActionInfo]]>) -> Request {
        let url = self.BASE_API_URL + "getPlaylistFriend.aspx"
        return Alamofire.request(.GET, url).responseJSON { response in
            if let data: AnyObject = response.result.value {
                let json = JSON(data)
                var dict = Dictionary<String, [ActionInfo]>()
                for (_, group): (String, JSON) in json["playlist"]["group"] {
                    var actionInfos = [ActionInfo]()
                    for (_, list): (String, JSON) in group["list"] {
                        actionInfos.append(ActionInfo.getFriendActionInfo(list))
                    }
                    dict[group["no"].string!] = actionInfos
                }
                cb.callback(dict, true, nil, nil)
            } else {
                cb.callback(nil, false, nil, nil)
            }
        }
    }
    
    func getPlaylistGallery(cb: Callback<[String : [ActionInfo]]>) -> Request {
        let url = self.BASE_API_URL + "getPlaylistGallery.aspx"
        return Alamofire.request(.GET, url).responseJSON { response in
            if let data: AnyObject = response.result.value {
                let json = JSON(data)
                var dict = Dictionary<String, [ActionInfo]>()
                for (_, actor): (String, JSON) in json["playlist"]["actor"] {
                    print(actor["name"].string)
                    var actionInfos = [ActionInfo]()
                    for (_, list): (String, JSON) in actor["list"] {
                        actionInfos.append(ActionInfo.getFriendActionInfo(list))
                    }
                    dict[actor["no"].string!] = actionInfos
                }
                cb.callback(dict, true, nil, nil)
            } else {
                cb.callback(nil, false, nil, nil)
            }
        }
    }
    
}

/*
 if let _ = FBSDKAccessToken.currentAccessToken() {
 // self.shareFacebookResult()
 let request = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "email,gender,link,first_name,last_name"], HTTPMethod: "GET")
 let connection = FBSDKGraphRequestConnection()
 connection.addRequest(request, completionHandler: { (conn, result, error) -> Void in
 if (error != nil) {
 print("\(error.localizedDescription)")
 } else {
 var json = JSON(result)
 
 // var params = Dictionary<String, AnyObject>()
 
 if let firstname = json["first_name"].string {
 self.keychain.set(firstname, forKey: "firstname")
 }
 
 if let lastname = json["last_name"].string {
 self.keychain.set(lastname, forKey: "lastname")
 }
 
 if let email = json["email"].string {
 self.keychain.set(email, forKey: "email")
 }
 
 if let gender = json["gender"].string {
 self.keychain.set(gender, forKey: "gender")
 }
 
 if let link = json["link"].string {
 self.keychain.set(link, forKey: "link")
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
 var parameters = [
 "access": "mobileapp",
 "caller": "json"
 ]
 
 if let uid = self.keychain.get("uid") {
 parameters["fakefbuid"] = uid
 }
 
 let fbuid = FBSDKAccessToken.currentAccessToken().userID
 self.keychain.set(fbuid, forKey: "uid")
 
 parameters["fbuid"] = fbuid
 
 // let dicPost: NSMutableDictionary = NSMutableDictionary()
 // let request = FBSDKGraphRequest(graphPath: "me", parameters: dicPost as [NSObject : AnyObject], HTTPMethod: "GET")
 let request = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "email,gender,link,first_name,last_name"], HTTPMethod: "GET")
 let connection = FBSDKGraphRequestConnection()
 connection.addRequest(request, completionHandler: { (conn, result, error) -> Void in
 if (error != nil) {
 print("\(error.localizedDescription)")
 } else {
 var json = JSON(result)
 
 // var params = Dictionary<String, AnyObject>()
 
 if let firstname = json["first_name"].string {
 parameters["firstname"] = json["first_name"].string
 if self.keychain.set(firstname, forKey: "firstname") {
 print("add success")
 } else {
 print("add failed")
 }
 }
 
 if let lastname = json["last_name"].string {
 parameters["lastname"] = json["last_name"].string
 self.keychain.set(lastname, forKey: "lastname")
 }
 
 if let email = json["email"].string {
 parameters["email"] = json["email"].string
 self.keychain.set(email, forKey: "email")
 }
 
 if let gender = json["gender"].string {
 parameters["gender"] = json["gender"].string
 self.keychain.set(gender, forKey: "gender")
 }
 
 if let link = json["link"].string {
 parameters["profilelink"] = json["link"].string
 self.keychain.set(link, forKey: "link")
 }
 
 for (key, value) in parameters {
 print("\(key): \(value)")
 }
 
 Alamofire.request(.POST, "http://www.estcolathai.com/volleyballmobile/api/mobile/getinfoV3NonToken.aspx", parameters: parameters)
 
 self.shareFacebookResult()
 }
 })
 
 connection.start()
 
 }
 })
 }*/