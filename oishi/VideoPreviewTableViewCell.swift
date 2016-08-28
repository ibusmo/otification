//
//  VideoPreviewTableViewCell.swift
//  oishi
//
//  Created by warinporn khantithamaporn on 8/27/2559 BE.
//  Copyright © 2559 com.rollingneko. All rights reserved.
//

import UIKit

class VideoPreviewTableViewCell: UITableViewCell {

    // height: 559
    
    var leftVideoPreviewView = VideoPreviewView()
    var rightVideoPreviewView = VideoPreviewView()
    
    var leftActionInfo: ActionInfo?
    var rightActionInfo: ActionInfo?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .None
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initVideoPreviewCell() {
        self.leftVideoPreviewView.removeFromSuperview()
        self.rightVideoPreviewView.removeFromSuperview()
        
        let videoPreviewSize = CGSizeMake(Otification.rWidth / 2.0, Otification.calculatedHeightFromRatio(560.0))
        self.leftVideoPreviewView = VideoPreviewView(frame: CGRectMake(0.0, Otification.calculatedHeightFromRatio(26.0), videoPreviewSize.width, videoPreviewSize.height))
        self.leftVideoPreviewView.backgroundColor = UIColor.clearColor()
        
        self.rightVideoPreviewView = VideoPreviewView(frame: CGRectMake(videoPreviewSize.width, 0.0, videoPreviewSize.width, videoPreviewSize.height), x: 38.0)
        self.rightVideoPreviewView.backgroundColor = UIColor.clearColor()
        
        self.contentView.addSubview(self.leftVideoPreviewView)
        self.contentView.addSubview(self.rightVideoPreviewView)
    }
    
    func initLeftVideoPreview(actionInfo: ActionInfo) {
        self.leftActionInfo = actionInfo
        self.leftVideoPreviewView.nameLabel.text = actionInfo.name
        if let urlString = actionInfo.galleryImageUrlString {
            let url = NSURL(string: urlString)
            self.leftVideoPreviewView.videoPreviewImageView.setImageWithProgressIndicatorAndURL(url, placeholderImage: nil)
        }
    }
    
    func initRightVideoPreview(actionInfo: ActionInfo) {
        self.rightActionInfo = actionInfo
        self.rightVideoPreviewView.nameLabel.text = actionInfo.name
    }
    
}
