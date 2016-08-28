//
//  VideoPreviewTableViewCell.swift
//  oishi
//
//  Created by warinporn khantithamaporn on 8/27/2559 BE.
//  Copyright © 2559 com.rollingneko. All rights reserved.
//

import UIKit

protocol VideoPreviewTableViewCellDelegate {
    func didSelectVideoPreviewAtIndex(index: Int)
}

class VideoPreviewTableViewCell: UITableViewCell {

    // height: 559
    
    var leftVideoPreviewView = VideoPreviewView()
    var rightVideoPreviewView = VideoPreviewView()
    
    var leftActionInfo: ActionInfo?
    var rightActionInfo: ActionInfo?
    
    var index: Int?
    
    var delegate: VideoPreviewTableViewCellDelegate?
    
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
    }
    
    func initLeftVideoPreview(actionInfo: ActionInfo) {
        self.leftActionInfo = actionInfo
        self.leftVideoPreviewView.nameLabel.text = actionInfo.name
        if let urlString = actionInfo.galleryImageUrlString {
            let url = NSURL(string: urlString)
            self.leftVideoPreviewView.videoFrameImageView.setImageWithProgressIndicatorAndURL(url, placeholderImage: UIImage(named: "gallery_vdo_placeholder"))
        }
        
        self.leftVideoPreviewView.videoPlaybackButton.tag = 0
        self.leftVideoPreviewView.videoPlaybackButton.addTarget(self, action: #selector(VideoPreviewTableViewCell.videoPlayBack(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.contentView.addSubview(self.leftVideoPreviewView)
    }
    
    func initRightVideoPreview(actionInfo: ActionInfo) {
        self.rightActionInfo = actionInfo
        self.rightVideoPreviewView.nameLabel.text = actionInfo.name
        if let urlString = actionInfo.galleryImageUrlString {
            let url = NSURL(string: urlString)
            self.rightVideoPreviewView.videoFrameImageView.setImageWithProgressIndicatorAndURL(url, placeholderImage: UIImage(named: "gallery_vdo_placeholder"))
        }
        
        self.rightVideoPreviewView.videoPlaybackButton.tag = 1
        self.rightVideoPreviewView.videoPlaybackButton.addTarget(self, action: #selector(VideoPreviewTableViewCell.videoPlayBack(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.contentView.addSubview(self.rightVideoPreviewView)
    }
    
    func videoPlayBack(button: UIButton) {
        if let index = self.index {
            if (button.tag == 0) {
                self.delegate?.didSelectVideoPreviewAtIndex(index * 2)
            } else {
                self.delegate?.didSelectVideoPreviewAtIndex((index * 2) + 1)
            }
        }
    }
    
}
