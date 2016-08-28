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
    
    private init() {}
    
    func getPlaylist(cb: Callback<[String : [ActionInfo]]>) -> Request {
        let url = self.BASE_API_URL + "getPlaylistAlarm.aspx"
        return Alamofire.request(.GET, url).responseJSON { response in
            if let data: AnyObject = response.result.value {
                let json = JSON(data)
                var dict = Dictionary<String, [ActionInfo]>()
                for (_, group): (String, JSON) in json["playlist"]["group"] {
                    var actionInfos = [ActionInfo]()
                    for (_, list): (String, JSON) in group["list"] {
                        actionInfos.append(ActionInfo.getActionInfo(list))
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