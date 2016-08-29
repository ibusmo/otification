//
//  VideoPreviewViewController.swift
//  oishi
//
//  Created by warinporn khantithamaporn on 8/29/2559 BE.
//  Copyright © 2559 com.rollingneko. All rights reserved.
//

import UIKit

class VideoPreviewViewController: UIViewController, DownloadViewControllerDelegate {
    
    var avPlayer = AVPlayer()
    var avPlayerLayer = AVPlayerLayer()
    var videoView = UIView()
    
    var bottomBar = UIView()
    var playImageView = UIImageView()
    var playButton = UIButton()
    var closeButton = UIButton()
    var timeTrack = M13ProgressViewBorderedBar()
    
    var download: DownloadViewController?
    
    var videoUrlString: String?
    var videoFilePath: String?
    var isCheckingPassed: Bool = false
    
    var duration: Float64 = 0
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.clearColor()

        // Do any additional setup after loading the view.
        let barSize = CGSizeMake(Otification.rWidth, Otification.calculatedHeightFromRatio(202.0))
        self.bottomBar.frame = CGRectMake(0.0, Otification.rHeight - barSize.height, barSize.width, barSize.height)
        self.bottomBar.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        self.bottomBar.layer.zPosition = 1000
        
        self.playImageView.frame = CGRectMake(Otification.calculatedWidthFromRatio(62.0), Otification.calculatedWidthFromRatio(33.0), Otification.calculatedWidthFromRatio(136.0), Otification.calculatedWidthFromRatio(136.0))
        self.playImageView.image = UIImage(named: "preview_video_play_button")
        self.playImageView.backgroundColor = UIColor.clearColor()
        
        self.playButton.frame = CGRectMake(Otification.calculatedWidthFromRatio(2.0), 0.0, Otification.calculatedWidthFromRatio(202.0), Otification.calculatedWidthFromRatio(202.0))
        self.playButton.backgroundColor = UIColor.clearColor()
        self.playButton.addTarget(self, action: #selector(VideoPreviewViewController.checkVideo), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.closeButton.frame = CGRectMake(Otification.calculatedWidthFromRatio(1000.0), Otification.calculatedHeightFromRatio(50.0), Otification.calculatedWidthFromRatio(193.0), Otification.calculatedHeightFromRatio(196.0))
        self.closeButton.setImage(UIImage(named: "tutorial_close_button"), forState: UIControlState.Normal)
        self.closeButton.addTarget(self, action: #selector(VideoPreviewViewController.closeDidTap), forControlEvents: UIControlEvents.TouchUpInside)
        self.closeButton.userInteractionEnabled = true
        self.closeButton.layer.zPosition = 1000
        
        let progressBarSize = CGSizeMake(Otification.rWidth - Otification.calculatedWidthFromRatio(326.0), Otification.calculatedHeightFromRatio(40.0))
        self.timeTrack.frame = CGRectMake(Otification.calculatedWidthFromRatio(264.0), Otification.calculatedHeightFromRatio((202.0 - 40.0) / 2.0), progressBarSize.width, progressBarSize.height)
        self.timeTrack.layer.cornerRadius = progressBarSize.height / 2.0
        self.timeTrack.clipsToBounds = true
        self.timeTrack.layer.borderColor = UIColor.whiteColor().CGColor
        self.timeTrack.layer.borderWidth = Otification.calculatedWidthFromRatio(8.0)
        self.timeTrack.primaryColor = UIColor.whiteColor()
        self.timeTrack.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        
        self.bottomBar.addSubview(self.playImageView)
        self.bottomBar.addSubview(self.playButton)
        self.bottomBar.addSubview(self.timeTrack)
        
        self.view.addSubview(self.videoView)
        self.videoView.addSubview(self.closeButton)
        self.videoView.addSubview(self.bottomBar)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(VideoPreviewViewController.playerDidPlayToEnd), name: AVPlayerItemDidPlayToEndTimeNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: AVPlayerItemDidPlayToEndTimeNotification, object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        self.checkVideo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkVideo() {
        // TODO: - check video exist in file
        if ((self.avPlayer.rate != 0) && (self.avPlayer.error == nil)) {
            self.avPlayer.pause()
        } else if (self.isCheckingPassed) {
            self.avPlayer.play()
        } else {
            if let videoUrlString = self.videoUrlString {
                let splitedString = videoUrlString.characters.split{$0 == "/"}.map(String.init)
                let fileName = splitedString[splitedString.count - 1]
                if let videoFilePath = self.getVideoFilePath(fileName) {
                    // TODO: - load and play
                    self.playVideo(videoFilePath)
                    self.isCheckingPassed = true
                } else {
                    // TODO: - download
                    self.download = DownloadViewController()
                    self.download!.modalPresentationStyle = .OverCurrentContext
                    
                    self.download!.videoUrlString = videoUrlString
                    self.download!.isDownloadVideoPreview = true
                    self.download!.delegate = self
                    
                    self.definesPresentationContext = true
                    self.presentViewController(self.download!, animated: false, completion: nil)
                }
            }
        }
    }
    
    func playVideo(videoFilePath: String) {
        self.avPlayerLayer.removeFromSuperlayer()
        self.avPlayer = AVPlayer(URL: NSURL.fileURLWithPath(videoFilePath))
        self.avPlayer.actionAtItemEnd = .None
        self.avPlayerLayer = AVPlayerLayer(player: self.avPlayer)
        self.videoView.frame = CGRectMake(0.0, 0.0, Otification.rWidth, Otification.rHeight)
        self.avPlayerLayer.frame = CGRectMake(0.0, 0.0, Otification.rWidth, Otification.rHeight)
        self.avPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.videoView.layer.addSublayer(self.avPlayerLayer)
        
        let item = avPlayer.currentItem
        self.duration = CMTimeGetSeconds((item?.asset.duration)!)
        
        print("duration: \(duration)")
        
        let interval = CMTimeMakeWithSeconds(0.1, 1000)
        CMTimeShow(interval)
        self.avPlayer.addPeriodicTimeObserverForInterval(interval, queue: nil, usingBlock: { time in
            self.timeTrack.setProgress(CGFloat(CGFloat(time.seconds) / CGFloat(self.duration)), animated: true)
        })
        
        self.avPlayer.play()
    }
    
    func playerDidPlayToEnd() {
        self.dismissViewControllerAnimated(false, completion: nil)
        self.avPlayer.pause()
        self.avPlayer.seekToTime(kCMTimeZero)
    }
    
    // MARK: - downloadvideocontrollerdelegate
    
    func finishedDownloadResources() {
        self.download?.dismissViewControllerAnimated(false, completion: nil)
        let splitedString = self.videoUrlString!.characters.split{$0 == "/"}.map(String.init)
        let fileName = splitedString[splitedString.count - 1]
        let videoFilePath = self.getVideoFilePath(fileName)
        self.isCheckingPassed = true
        self.playVideo(videoFilePath!)
    }
    
    func failedDownloadResources() {
    }
    
    func didCancelDownloadResources() {
    }
    
    func closeDidTap() {
        self.avPlayer.pause()
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    // MARK: - videofilepath
    
    func getVideoFilePath(fileName: String) -> String? {
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentsDirectory: AnyObject = paths[0]
        var dataPath = documentsDirectory.stringByAppendingPathComponent("video")
        
        let fileManager = NSFileManager()
        if (!fileManager.fileExistsAtPath(dataPath)) {
            do {
                try NSFileManager.defaultManager().createDirectoryAtPath(dataPath, withIntermediateDirectories: false, attributes: nil)
                print("check")
            } catch let error as NSError {
                print(error.localizedDescription);
            }
        } else {
            dataPath = dataPath + "/\(fileName)"
            print("dataPath: \(dataPath)")
            if (fileManager.fileExistsAtPath(dataPath)) {
                return dataPath
            } else {
                return nil
            }
        }
        
        return nil
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
