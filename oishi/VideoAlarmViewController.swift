//
//  VideoAlarmViewController.swift
//  oishi
//
//  Created by warinporn khantithamaporn on 8/25/2559 BE.
//  Copyright © 2559 com.rollingneko. All rights reserved.
//

import UIKit

class VideoAlarmViewController: UIViewController, SnoozeButtonDelegate {
    
    var avPlayer = AVPlayer()
    var avPlayerLayer = AVPlayerLayer()
    var videoView = UIView()
    
    var snoozeButton = SnoozeButton()
    
    var uid: String?
    var videoFileName: String?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.clearColor()
        self.videoView.backgroundColor = UIColor.clearColor()
        
        // Do any additional setup after loading the view.
        if let fileName = self.videoFileName {
            let filePath = self.getVideoFilePath(fileName)
            print("filePath: \(filePath)")
            self.avPlayer = AVPlayer(URL: NSURL.fileURLWithPath(filePath!))
            self.avPlayer.actionAtItemEnd = .None
            self.avPlayerLayer = AVPlayerLayer(player: self.avPlayer)
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(VideoAlarmViewController.replayVideo(_:)), name: AVPlayerItemDidPlayToEndTimeNotification, object: self.avPlayer.currentItem)
            
            self.videoView.frame = CGRectMake(0.0, 0.0, Otification.rWidth, Otification.rHeight)
            self.avPlayerLayer.frame = CGRectMake(0.0, 0.0, Otification.rWidth, Otification.rHeight)
            self.avPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
            
            self.videoView.layer.addSublayer(self.avPlayerLayer)
            
            self.view.addSubview(self.videoView)
        }
        
        // snoozebutton
        let snoozeButtonSize = CGSizeMake(Otification.calculatedWidthFromRatio(1236.0), Otification.calculatedHeightFromRatio(315.0))
        self.snoozeButton.frame = CGRectMake((Otification.rWidth - snoozeButtonSize.width) / 2.0, Otification.calculatedHeightFromRatio(1832.0), snoozeButtonSize.width, snoozeButtonSize.height)
        self.snoozeButton.delegate = self
        self.snoozeButton.initComponent()
        
        self.view.addSubview(self.snoozeButton)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.avPlayer.play()
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: AVPlayerItemDidPlayToEndTimeNotification, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - video playback
    
    func replayVideo(notification: NSNotification) {
        let item = notification.object as! AVPlayerItem
        item.seekToTime(kCMTimeZero)
    }
    
    func stopVideo() {
        self.avPlayer.pause()
    }
    
    // MARK: - snoozebuttondelegate
    
    func snoozeDidDrag(snooze: SnoozeButton) {
        if (snooze.state == .Stop) {
            // TODO: - cancel
            self.stopVideo()
            ViewControllerManager.sharedInstance.presentMyList()
            let index = AlarmManager.sharedInstance.findAlarm(self.uid!)
            let alarm = AlarmManager.sharedInstance.alarms[index]
            alarm.on = false
            AlarmManager.sharedInstance.saveAlarm(alarm)
        } else if (snooze.state == .Snooze) {
            // TODO: - set new localnotification with the same noti
            self.stopVideo()
            ViewControllerManager.sharedInstance.presentMyList()
            AlarmManager.sharedInstance.setSnoozeAlarm(self.uid!)
            let index = AlarmManager.sharedInstance.findAlarm(self.uid!)
            let alarm = AlarmManager.sharedInstance.alarms[index]
            AlarmManager.sharedInstance.setAlarm(alarm)
        } else {
            // do nothing for .normal state
        }
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
            } catch let error as NSError {
                print(error.localizedDescription);
            }
        } else {
            dataPath = dataPath + "/\(fileName)"
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
