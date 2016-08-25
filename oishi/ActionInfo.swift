//
//  ActionInfo.swift
//  oishi
//
//  Created by warinporn khantithamaporn on 8/26/2559 BE.
//  Copyright © 2559 com.rollingneko. All rights reserved.
//

import Foundation
import SwiftyJSON

class ActionInfo {
    
    var id: String?
    var active: String?
    var version: String?
    var actor: String?
    var type: String?
    var no: String?
    
    var name: String?
    var notiTitle: String?
    var notiMessage: String?
    
    var videoUrlString: String?
    var audioUrlString: String?
    
    init(id: String?, active: String?, version: String?, actor: String?, type: String?, no: String?, name: String?, notiTitle: String?, notiMessage: String?, videoUrlString: String?, audioUrlString: String?) {
        self.id = id
        self.active = active
        self.version = version
        self.actor = actor
        self.type = type
        self.no = no
        
        self.name = name
        self.notiTitle = notiTitle
        self.notiMessage = notiMessage
        
        self.videoUrlString = videoUrlString
        self.audioUrlString = audioUrlString
    }
    
    class func getActionInfo(json: JSON) -> ActionInfo {
        let id = json["id"].string
        let active = json["active"].string
        let version = json["version"].string
        let actor = json["actor"].string
        let type = json["type"].string
        let no = json["no"].string
        
        let name = json["name"].string
        let notiTitle = json["noti_title"].string
        let notiMessage = json["noti_message"].string
        
        let videoUrlString = json["video"].string
        let audioUrlString = json["audio_ios"].string
        
        return ActionInfo(id: id, active: active, version: version, actor: actor, type: type, no: no, name: name, notiTitle: notiTitle, notiMessage: notiMessage, videoUrlString: videoUrlString, audioUrlString: audioUrlString)
    }
    
}