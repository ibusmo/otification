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