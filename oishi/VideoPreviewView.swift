//
//  VideoPreviewView.swift
//  oishi
//
//  Created by warinporn khantithamaporn on 8/27/2559 BE.
//  Copyright © 2559 com.rollingneko. All rights reserved.
//

import UIKit

protocol VideoPreviewViewDelegate {
    func fbDidTap(index: Int)
    func lineDidTap(index: Int)
}

class VideoPreviewView: UIView {
    
    // vdoframe 116, 0, 501, 393
    var videoFrameImageView = UIImageView()
    var videoPlaybackButton = UIButton()
    
    var nameBackgroundImageView = UIImageView()
    var nameLabel = UILabel()
    
    var fbButton = UIButton()
    var lineButton = UIButton()
    
    var delegate: VideoPreviewViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let videoFrameSize = CGSizeMake(Otification.calculatedWidthFromRatio(501.0), Otification.calculatedWidthFromRatio(393.0))
        self.videoFrameImageView.frame = CGRectMake(Otification.calculatedWidthFromRatio(116.0), 0.0, videoFrameSize.width, videoFrameSize.height)
        self.videoFrameImageView.image = UIImage(named: "gallery_vdo_frame")
        self.videoFrameImageView.backgroundColor = UIColor.clearColor()
        
        self.videoPlaybackButton.frame = CGRectMake(Otification.calculatedWidthFromRatio(116.0), 0.0, videoFrameSize.width, videoFrameSize.height)
        self.videoPlaybackButton.backgroundColor = UIColor.clearColor()
        
        let nameLabelBackgroundSize = CGSizeMake(Otification.calculatedWidthFromRatio(470.0), Otification.calculatedWidthFromRatio(134.0))
        self.nameBackgroundImageView.frame = CGRectMake(Otification.calculatedWidthFromRatio(113.0), Otification.calculatedWidthFromRatio(310.0), nameLabelBackgroundSize.width, nameLabelBackgroundSize.height)
        self.nameBackgroundImageView.image = UIImage(named: "gallery_name_bg")
        
        self.nameLabel.frame = CGRectMake(Otification.calculatedWidthFromRatio(113.0), Otification.calculatedWidthFromRatio(304.0), nameLabelBackgroundSize.width, nameLabelBackgroundSize.height)
        self.nameLabel.transform = CGAffineTransformMakeRotation(-0.0825)
        self.nameLabel.font = UIFont(name: Otification.DBHELVETHAICA_X_BOLD_ITALIC, size: Otification.calculatedHeightFromRatio(50.0))
        self.nameLabel.textColor = UIColor.whiteColor()
        self.nameLabel.textAlignment = .Center
        
        let buttonSize = CGSizeMake(Otification.calculatedWidthFromRatio(259.0), Otification.calculatedWidthFromRatio(111.0))
        self.fbButton.frame = CGRectMake(Otification.calculatedWidthFromRatio(98.0), Otification.calculatedHeightFromRatio(430.0), buttonSize.width, buttonSize.height)
        self.fbButton.setImage(UIImage(named: "gallery_fb_button"), forState: UIControlState.Normal)
        self.fbButton.addTarget(self, action: #selector(VideoPreviewView.fbDidTap), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.lineButton.frame = CGRectMake(Otification.calculatedWidthFromRatio(350.0), Otification.calculatedHeightFromRatio(415.0), buttonSize.width, buttonSize.height)
        self.lineButton.setImage(UIImage(named: "gallery_line_button"), forState: UIControlState.Normal)
        self.lineButton.addTarget(self, action: #selector(VideoPreviewView.lineDidTap), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.addSubview(self.videoFrameImageView)
        self.addSubview(self.nameBackgroundImageView)
        self.addSubview(self.nameLabel)
        self.addSubview(self.fbButton)
        self.addSubview(self.lineButton)
        self.addSubview(self.videoPlaybackButton)
    }
    
    init(frame: CGRect, x: CGFloat) {
        super.init(frame: frame)
        
        let videoFrameSize = CGSizeMake(Otification.calculatedWidthFromRatio(501.0), Otification.calculatedWidthFromRatio(393.0))
        self.videoFrameImageView.frame = CGRectMake(Otification.calculatedWidthFromRatio(x), 0.0, videoFrameSize.width, videoFrameSize.height)
        self.videoFrameImageView.image = UIImage(named: "gallery_vdo_placeholder")
        self.videoFrameImageView.backgroundColor = UIColor.clearColor()
        
        self.videoPlaybackButton.frame = CGRectMake(Otification.calculatedWidthFromRatio(x), 0.0, videoFrameSize.width, videoFrameSize.height)
        self.videoPlaybackButton.backgroundColor = UIColor.clearColor()
        
        let nameLabelBackgroundSize = CGSizeMake(Otification.calculatedWidthFromRatio(470.0), Otification.calculatedWidthFromRatio(134.0))
        self.nameBackgroundImageView.frame = CGRectMake(Otification.calculatedWidthFromRatio(x - 3.0), Otification.calculatedWidthFromRatio(310.0), nameLabelBackgroundSize.width, nameLabelBackgroundSize.height)
        self.nameBackgroundImageView.image = UIImage(named: "gallery_name_bg")
        
        self.nameLabel.frame = CGRectMake(Otification.calculatedWidthFromRatio(x - 3.0), Otification.calculatedWidthFromRatio(304.0), nameLabelBackgroundSize.width, nameLabelBackgroundSize.height)
        self.nameLabel.transform = CGAffineTransformMakeRotation(-0.0825)
        self.nameLabel.font = UIFont(name: Otification.DBHELVETHAICA_X_BOLD_ITALIC, size: Otification.calculatedHeightFromRatio(50.0))
        self.nameLabel.textColor = UIColor.whiteColor()
        self.nameLabel.textAlignment = .Center
        
        let buttonSize = CGSizeMake(Otification.calculatedWidthFromRatio(259.0), Otification.calculatedWidthFromRatio(111.0))
        self.fbButton.frame = CGRectMake(Otification.calculatedWidthFromRatio(x - 15.0), Otification.calculatedHeightFromRatio(430.0), buttonSize.width, buttonSize.height)
        self.fbButton.setImage(UIImage(named: "gallery_fb_button"), forState: UIControlState.Normal)
        self.fbButton.addTarget(self, action: #selector(VideoPreviewView.fbDidTap), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.lineButton.frame = CGRectMake(Otification.calculatedWidthFromRatio(274.0), Otification.calculatedHeightFromRatio(415.0), buttonSize.width, buttonSize.height)
        self.lineButton.setImage(UIImage(named: "gallery_line_button"), forState: UIControlState.Normal)
        self.lineButton.addTarget(self, action: #selector(VideoPreviewView.lineDidTap), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.addSubview(self.videoFrameImageView)
        self.addSubview(self.nameBackgroundImageView)
        self.addSubview(self.nameLabel)
        self.addSubview(self.fbButton)
        self.addSubview(self.lineButton)
        self.addSubview(self.videoPlaybackButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fbDidTap() {
        self.delegate?.fbDidTap(self.tag)
    }
    
    func lineDidTap() {
        self.delegate?.lineDidTap(self.tag)
    }

}
