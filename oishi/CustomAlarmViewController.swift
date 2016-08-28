//
//  CustomAlarmViewController.swift
//  oishi
//
//  Created by warinporn khantithamaporn on 8/23/2559 BE.
//  Copyright © 2559 com.rollingneko. All rights reserved.
//

import UIKit
import LLSimpleCamera
import AVFoundation
import Photos

class CustomAlarmViewController: OishiViewController, AVAudioRecorderDelegate {
    
    // MARK: - views
    
    var soundRecordTitle = UIImageView()
    var soundRecordButton = UIButton()
    var soundPlaybackButton = UIButton()
    var soundRecordIndicator = UIImageView()
    var yellowSoundRecordIndicator = UIImageView()
    var isRecordingAudio: Int = 0
    
    var vdoRecordTitle = UIImageView()
    var vdoRecordButton = UIButton()
    
    var vdoFrameImageView = UIImageView()
    
    // MARK: - audio recorder
    
    var recorder: AVAudioRecorder!
    var audioPlayer = AVAudioPlayer()
    var recordedSound: Bool = false
    
    // MARK: - vdo player
    
    var videoUrl: NSURL?
    var avPlayer = AVPlayer()
    var avPlayerLayer = AVPlayerLayer()
    var vdoView = UIView()
    var vdoPlayButton = UIButton() // y=956
    var recordedVideo: Bool = false
    
    // MARK: - camera view
    
    var camera: LLSimpleCamera?
    var cameraTopBar = UIView()
    var timeLabel = UILabel()
    var recordingIndicator = UIView()
    var snapButton = UIButton()
    var closeCameraButton = UIButton()
    var swapCameraButton = UIButton()
    
    // MARK: - utilites
    
    var timer = NSTimer()
    var counter: Int = 0
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tabBar.swapState = false
        self.tabBar.setBottomBarView("ยกเลิก", rightButtonTitle: "บันทึก", leftButtonSelected: true, leftIndicator: "", rightIndicator: "")
        
        self.backgroundImageView.frame = CGRectMake(0.0, 0.0, Otification.rWidth, Otification.rHeight)
        self.backgroundImageView.image = UIImage(named: "custom_bg")
        self.backgroundImageView.contentMode = UIViewContentMode.ScaleAspectFill
        
        self.initCustomAlarm()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.camera?.stop()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - view initialize
    
    func initCustomAlarm() {
        let soundTitleSize = CGSizeMake(Otification.calculatedWidthFromRatio(853.0), Otification.calculatedHeightFromRatio(137.0))
        self.soundRecordTitle.frame = CGRectMake((Otification.rWidth - soundTitleSize.width) / 2.0, Otification.calculatedHeightFromRatio(280.0), soundTitleSize.width, soundTitleSize.height)
        self.soundRecordTitle.image = UIImage(named: "sound_record_title")
        
        let soundButtonSize = CGSizeMake(Otification.calculatedWidthFromRatio(239.0), Otification.calculatedHeightFromRatio(243.0))
        self.soundRecordButton.frame = CGRectMake(Otification.calculatedWidthFromRatio(356.0), Otification.calculatedHeightFromRatio(208.0 + 240.0), soundButtonSize.width, soundButtonSize.height)
        self.soundRecordButton.setImage(UIImage(named: "sound_record_button"), forState: UIControlState.Normal)
        
        let soundIndicatorSize = CGSizeMake(Otification.calculatedWidthFromRatio(276.0), Otification.calculatedHeightFromRatio(335.0))
        self.soundRecordIndicator.frame = CGRectMake(Otification.calculatedWidthFromRatio(240.0), Otification.calculatedHeightFromRatio(208.0 + 100.0), soundIndicatorSize.width, soundIndicatorSize.height)
        self.soundRecordIndicator.image = UIImage(named: "record_gray")
        self.soundRecordIndicator.backgroundColor = UIColor.clearColor()
        
        self.yellowSoundRecordIndicator.frame = CGRectMake(Otification.calculatedWidthFromRatio(240.0), Otification.calculatedHeightFromRatio(208.0 + 100.0), soundIndicatorSize.width, soundIndicatorSize.height)
        self.yellowSoundRecordIndicator.image = UIImage(named: "record_yellow")
        self.yellowSoundRecordIndicator.backgroundColor = UIColor.clearColor()
        
        self.soundRecordButton.addTarget(self, action: #selector(CustomAlarmViewController.prepareAudioRecording), forControlEvents: UIControlEvents.TouchUpInside)
        self.soundRecordButton.addTarget(self, action: #selector(CustomAlarmViewController.stopAudioRecording), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.soundPlaybackButton.frame = CGRectMake(Otification.calculatedWidthFromRatio(650.0), Otification.calculatedHeightFromRatio(208.0 + 240.0), soundButtonSize.width, soundButtonSize.height)
        self.soundPlaybackButton.setImage(UIImage(named: "sound_playback_button"), forState: UIControlState.Normal)
        self.soundPlaybackButton.addTarget(self, action: #selector(CustomAlarmViewController.playRecordedAudio), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(self.soundRecordTitle)
        self.view.addSubview(self.soundRecordButton)
        self.view.addSubview(self.soundPlaybackButton)
        self.view.addSubview(self.yellowSoundRecordIndicator)
        self.view.addSubview(self.soundRecordIndicator)
        
        let vdoTitleSize = CGSizeMake(Otification.calculatedWidthFromRatio(318.0), Otification.calculatedHeightFromRatio(95.0))
        self.vdoRecordTitle.frame = CGRectMake((Otification.rWidth - vdoTitleSize.width) / 2.0, Otification.calculatedHeightFromRatio(208.0 + 616.0), vdoTitleSize.width, vdoTitleSize.height)
        self.vdoRecordTitle.image = UIImage(named: "vdo_record_title")
        
        let vdoRecordButtonSize = CGSizeMake(Otification.calculatedWidthFromRatio(625.0), Otification.calculatedHeightFromRatio(215.0))
        self.vdoRecordButton.frame = CGRectMake((Otification.rWidth - vdoRecordButtonSize.width) / 2.0, Otification.calculatedHeightFromRatio(208.0 + 1580.0), vdoRecordButtonSize.width, vdoRecordButtonSize.height)
        self.vdoRecordButton.setImage(UIImage(named: "vdo_record_button"), forState: UIControlState.Normal)
        self.vdoRecordButton.addTarget(self, action: #selector(CustomAlarmViewController.presentCameraView), forControlEvents: UIControlEvents.TouchUpInside)
        
        let vdoFrameSize = CGSizeMake(Otification.calculatedWidthFromRatio(843.0), Otification.calculatedHeightFromRatio(759.0))
        self.vdoFrameImageView.frame = CGRectMake(Otification.calculatedWidthFromRatio(242.0), Otification.calculatedHeightFromRatio(208.0 + 723.0), vdoFrameSize.width, vdoFrameSize.height)
        self.vdoFrameImageView.image = UIImage(named: "no_vdo_recorded")
        
        self.vdoView.frame = CGRectMake(Otification.calculatedWidthFromRatio(242.0), Otification.calculatedHeightFromRatio(208.0 + 723.0), vdoFrameSize.width, vdoFrameSize.height)
        self.vdoView.backgroundColor = UIColor.clearColor()
        
        let vdoPlayButtonSize = CGSizeMake(Otification.calculatedWidthFromRatio(225), Otification.calculatedHeightFromRatio(225.0))
        self.vdoPlayButton.frame = CGRectMake(Otification.calculatedWidthFromRatio(522.0), Otification.calculatedHeightFromRatio(208.0 + 956.0), vdoPlayButtonSize.width, vdoPlayButtonSize.height)
        self.vdoPlayButton.setImage(UIImage(named: "vdo_playback_button"), forState: UIControlState.Normal)
        
        self.view.addSubview(self.vdoRecordTitle)
        self.view.addSubview(self.vdoRecordButton)
        self.view.addSubview(self.vdoView)
        self.view.addSubview(self.vdoFrameImageView)
    }
    
    func initCameraView() {
        self.cameraTopBar = UIView(frame: CGRectMake(0.0, 0.0, Otification.rWidth, Otification.calculatedHeightFromRatio(208.0)))
        self.cameraTopBar.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.25)
        
        let timeLabelSize = CGSizeMake(Otification.calculatedWidthFromRatio(300.0), Otification.calculatedHeightFromRatio(208.0))
        self.timeLabel.frame = CGRectMake((Otification.rWidth - timeLabelSize.width) / 2.0, 0.0, timeLabelSize.width, timeLabelSize.height)
        self.timeLabel.font = UIFont(name: Otification.DBHELVETHAICA_X_REGULAR, size: Otification.calculatedHeightFromRatio(140.0))
        self.timeLabel.textAlignment = .Center
        self.timeLabel.textColor = UIColor.whiteColor()
        self.timeLabel.text = "00 : 00"
        
        let closeButtonSize = CGSizeMake(Otification.calculatedWidthFromRatio(120.0), Otification.calculatedHeightFromRatio(120.0))
        let closeImageView = UIImageView(frame: CGRectMake(Otification.calculatedWidthFromRatio(44.0), Otification.calculatedWidthFromRatio(44.0), closeButtonSize.height, closeButtonSize.height))
        closeImageView.image = UIImage(named: "close_camera_button")
        self.closeCameraButton.frame = CGRectMake(0.0, 0.0, Otification.calculatedHeightFromRatio(208.0), Otification.calculatedHeightFromRatio(208.0))
        self.closeCameraButton.addTarget(self, action: #selector(CustomAlarmViewController.dismissCameraView), forControlEvents: UIControlEvents.TouchUpInside)
        
        let swapImageSize = CGSizeMake(Otification.calculatedWidthFromRatio(131.0), Otification.calculatedHeightFromRatio(100.0))
        let swapImageView = UIImageView(frame: CGRectMake(Otification.rWidth - swapImageSize.width - Otification.calculatedWidthFromRatio(44.0), Otification.calculatedWidthFromRatio(54.0), swapImageSize.width, swapImageSize.height))
        swapImageView.image = UIImage(named: "camera_switch")
        self.swapCameraButton.frame = CGRectMake(Otification.rWidth - Otification.calculatedWidthFromRatio(208.0), 0.0, Otification.calculatedHeightFromRatio(208.0), Otification.calculatedHeightFromRatio(208.0))
        self.swapCameraButton.addTarget(self, action: #selector(CustomAlarmViewController.swapCamera), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.recordingIndicator.frame = CGRectMake(self.timeLabel.frame.origin.x - Otification.calculatedWidthFromRatio(100.0), (Otification.calculatedHeightFromRatio(208.0) - Otification.calculatedHeightFromRatio(50.0)) / 2.0, Otification.calculatedHeightFromRatio(50.0), Otification.calculatedHeightFromRatio(50.0))
        self.recordingIndicator.backgroundColor = UIColor.redColor()
        self.recordingIndicator.layer.cornerRadius = Otification.calculatedHeightFromRatio(50.0) / 2.0
        self.recordingIndicator.clipsToBounds = true
        
        let snapButtonSize = CGSizeMake(Otification.calculatedWidthFromRatio(260.0), Otification.calculatedWidthFromRatio(260.0))
        self.snapButton.frame = CGRectMake((Otification.rWidth - snapButtonSize.width) / 2.0, (Otification.rHeight - snapButtonSize.height) - Otification.calculatedHeightFromRatio(50.0), snapButtonSize.width, snapButtonSize.height)
        self.snapButton.clipsToBounds = true
        self.snapButton.layer.cornerRadius = self.snapButton.frame.size.width / 2.0
        self.snapButton.layer.borderColor = UIColor.whiteColor().CGColor
        self.snapButton.layer.borderWidth = Otification.calculatedHeightFromRatio(20.0)
        self.snapButton.backgroundColor = UIColor.redColor().colorWithAlphaComponent(1.0)
        self.snapButton.addTarget(self, action: #selector(CustomAlarmViewController.snapDidTap), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.cameraTopBar.addSubview(closeImageView)
        self.cameraTopBar.addSubview(self.closeCameraButton)
        self.cameraTopBar.addSubview(swapImageView)
        self.cameraTopBar.addSubview(self.swapCameraButton)
        self.cameraTopBar.addSubview(self.timeLabel)
       
        self.camera?.view.backgroundColor = UIColor.blackColor()
        self.camera?.view.addSubview(self.cameraTopBar)
        self.camera?.view.addSubview(self.snapButton)
    }
    
    // MARK: - oishitabbardelegate
    
    override func leftButtonDidTap() {
        ViewControllerManager.sharedInstance.presentCreateAlarm()
    }
    
    override func rightButtonDidTap() {
        if (self.recordedSound && self.recordedVideo) {
            // TODO: - save alarm
            AlarmManager.sharedInstance.unsaveAlarm?.custom = true
            if (AlarmManager.sharedInstance.saveAlarm()) {
                ViewControllerManager.sharedInstance.presentMyList()
            } else {
                // TODO: - sth error
            }
        } else {
            // TODO: - alert user -> should record both media
        }
    }
    
    // MARK: - audio
    
    func prepareAudioRecording() {
        print("prepareAudioRecording")
        
        if (self.isRecordingAudio == 0 || self.isRecordingAudio == 3) {
            self.isRecordingAudio = 1
            self.updateSoundRecordingIndicator()
            let session = AVAudioSession.sharedInstance()
            do {
                try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
                try session.setActive(true)
                session.requestRecordPermission() { [unowned self] (allowed: Bool) -> Void in
                    dispatch_async(dispatch_get_main_queue()) {
                        if allowed {
                            self.startAudioRecording()
                        } else {
                            // failed to record!
                            self.isRecordingAudio = 0
                            self.updateSoundRecordingIndicator()
                        }
                    }
                }
            } catch {
                // failed to record!
                self.isRecordingAudio = 0
                self.updateSoundRecordingIndicator()
            }
        }
    }
    
    func startAudioRecording() {
        let filePath = self.getSoundFilePath()
        
        self.isRecordingAudio = 2
        self.updateSoundRecordingIndicator()
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatAppleIMA4),
            AVSampleRateKey: 44100.0,
            AVNumberOfChannelsKey: 2 as NSNumber,
            AVEncoderAudioQualityKey: AVAudioQuality.High.rawValue
        ]
        
        do {
            self.recorder = try AVAudioRecorder(URL: NSURL.fileURLWithPath(filePath), settings: settings)
            self.recorder.delegate = self
            self.recorder.prepareToRecord()
            self.recorder.record()
            print("startAudioRecording")
            self.timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: #selector(CustomAlarmViewController.exceedAudioRecordTime), userInfo: nil, repeats: false)
        } catch {
            print(error)
        }
    }
    
    func stopAudioRecording() {
        print("stopAudioRecording")
        if (self.isRecordingAudio == 2) {
            self.recorder.stop()
            self.isRecordingAudio = 0
        }
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if (flag) {
            print("audioRecorderDidFinishRecording")
            self.recordedSound = true
            self.isRecordingAudio = 3
            self.updateSoundRecordingIndicator()
        } else {
            
        }
    }
    
    func playRecordedAudio() {
        do {
            try self.audioPlayer = AVAudioPlayer(contentsOfURL: NSURL.fileURLWithPath(self.getSoundFilePath()))
            self.audioPlayer.prepareToPlay()
            self.audioPlayer.play()
        } catch {
            
        }
    }
    
    func exceedAudioRecordTime() {
        self.counter = 0
        self.timer.invalidate()
        self.recorder.stop()
    }
    
    // MARK: - camera
    
    func presentCameraView() {
        self.camera = LLSimpleCamera(quality: AVCaptureSessionPresetHigh, position: LLCameraPositionFront, videoEnabled: true)
        self.initCameraView()
        self.camera?.view.layer.zPosition = 1001
        self.camera!.attachToViewController(self, withFrame: CGRectMake(0.0, Otification.rHeight, Otification.rWidth, Otification.rHeight))
        self.camera?.start()
        UIView.animateWithDuration(0.6, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            var frame = self.camera?.view.frame
            frame?.origin.y = 0
            self.camera?.view.frame = frame!
            }, completion: { finished in
        })
    }
    
    func dismissCameraView() {
        self.snapButton.layer.removeAllAnimations()
        self.recordingIndicator.layer.removeAllAnimations()
        self.timer.invalidate()
        self.counter = 0
        self.camera?.view.removeFromSuperview()
    }
    
    func snapDidTap() {
        print("snapDidTap")
        if (!(self.camera?.recording)!) {
            self.recordingIndicator.alpha = 0.0
            self.cameraTopBar.addSubview(self.recordingIndicator)
            UIView.animateWithDuration(0.5, delay: 0.0, options: [UIViewAnimationOptions.Repeat, UIViewAnimationOptions.Autoreverse], animations: {
                self.recordingIndicator.alpha = 0.0
                self.recordingIndicator.alpha = 1.0
                }, completion: { finished in
            })
            // TODO: - start recording
            let uid = AlarmManager.sharedInstance.unsaveAlarm?.uid!
            self.videoUrl = self.getVideoBaseURL()?.URLByAppendingPathComponent(uid!).URLByAppendingPathExtension("mov")
            self.camera?.startRecordingWithOutputUrl(self.videoUrl!, didRecord: { (camera: LLSimpleCamera!, outputFileUrl: NSURL!, error: NSError!) in
                if (error == nil) {
                    print("video recorded at \(outputFileUrl.absoluteString)")
                    self.recordedVideo = true
                    self.videoUrl = outputFileUrl
                    let string = outputFileUrl.absoluteString
                    UISaveVideoAtPathToSavedPhotosAlbum(string.substringWithRange(Range<String.Index>(start: string.startIndex.advancedBy(7), end: string.endIndex)), nil, nil, nil)
                    self.presentRecordedVideo()
                } else {
                    print(error.localizedDescription)
                }
            })
            self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(CustomAlarmViewController.updateTimeLabel), userInfo: nil, repeats: true)
        } else {
            self.camera?.stopRecording()
            self.snapButton.layer.removeAllAnimations()
            self.snapButton.backgroundColor = UIColor.redColor().colorWithAlphaComponent(1.0)
            
            self.timer.invalidate()
            self.counter = 0
            self.camera?.view.removeFromSuperview()
            self.camera?.stop()
        }
    }
    
    func updateTimeLabel() {
        self.counter += 1
        if (self.counter <= 5) {
            self.timeLabel.text = "00 : 0\(self.counter)"
        }
        if (self.counter == 5) {
            self.camera?.stopRecording()
            self.snapButton.layer.removeAllAnimations()
            self.recordingIndicator.layer.removeAllAnimations()
        }
        if (self.counter >= 7) {
            self.timer.invalidate()
            self.counter = 0
            self.camera?.stop()
            self.camera?.view.removeFromSuperview()
        }
    }
    
    func swapCamera() {
        self.camera?.togglePosition()
    }
    
    // MARK: - vdo
    
    func presentRecordedVideo() {
        if let url = self.videoUrl {
            self.avPlayer = AVPlayer(URL: url)
            self.avPlayerLayer = AVPlayerLayer(player: self.avPlayer)
            let frame = self.vdoFrameImageView.frame
            self.avPlayerLayer.frame = CGRectMake(0.0, 0.0, frame.size.width, frame.size.height)
            self.avPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
            
            let mask = UIImageView(frame: CGRectMake(0.0, 0.0, Otification.calculatedWidthFromRatio(785.0), Otification.calculatedHeightFromRatio(689.0)))
            mask.image = UIImage(named: "vdo_masking")
            
            self.avPlayerLayer.mask = mask.layer
            
            self.vdoView.layer.addSublayer(self.avPlayerLayer)
            self.vdoFrameImageView.image = UIImage(named: "vdo_frame_2")
            
            self.view.addSubview(self.vdoPlayButton)
        }
    }
    
    // MARK: - file management
    
    func getVideoBaseURL() -> NSURL? {
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentsDirectory: AnyObject = paths[0]
        let dataPath = documentsDirectory.stringByAppendingPathComponent("video")
        
        let fileManager = NSFileManager()
        if (!fileManager.fileExistsAtPath(dataPath)) {
            do {
                try NSFileManager.defaultManager().createDirectoryAtPath(dataPath, withIntermediateDirectories: false, attributes: nil)
                print("check")
            } catch let error as NSError {
                print(error.localizedDescription);
            }
        } else {
            print("video path \(dataPath)/tempVideo.mov")
            if (fileManager.fileExistsAtPath(dataPath + "/tempVideo.mov")) {
                print("tempVideo.mov exist")
                self.removeTempVideo("tempVideo", fileExtension: "mov")
            } else {
                print("tempVideo.mov not exist")
            }
        }
        
        return NSURL(string: "file://" + dataPath)
    }
    
    func getSoundFilePath() -> String {
        let libraryPath = NSSearchPathForDirectoriesInDomains(.LibraryDirectory, .UserDomainMask, true)[0]
        let soundsPath = libraryPath + "/Sounds"
        var filePath: String = soundsPath
        if let uid = AlarmManager.sharedInstance.unsaveAlarm?.uid {
            filePath = soundsPath + "/\(uid).caf"
            print("filePath: \(filePath)")
        }
        
        let fileManager = NSFileManager.defaultManager()
        do {
            if (!fileManager.fileExistsAtPath(soundsPath)) {
                try fileManager.createDirectoryAtPath(soundsPath, withIntermediateDirectories: false, attributes: nil)
            }
            
        } catch let error1 as NSError {
            print("error" + error1.description)
        }
        
        return filePath
    }
    
    func getSoundBaseURL() -> NSURL? {
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentsDirectory: AnyObject = paths[0]
        let dataPath = documentsDirectory.stringByAppendingPathComponent("sound")
        
        let fileManager = NSFileManager()
        if (!fileManager.fileExistsAtPath(dataPath)) {
            do {
                try NSFileManager.defaultManager().createDirectoryAtPath(dataPath, withIntermediateDirectories: false, attributes: nil)
            } catch let error as NSError {
                print(error.localizedDescription);
            }
        } else {
            print("video path \(dataPath)/tempSound.caf")
            if (fileManager.fileExistsAtPath(dataPath + "/tempSound.m41")) {
                print("tempSound.caf exist")
                self.removeTempSound("tempSound", fileExtension: "m41")
            } else {
                print("tempSound.caf not exist")
            }
        }
        
        return NSURL(string: "file://" + dataPath)
    }
    
    // copy sound file to /Library/Sounds directory, it will be auto detect and played when a push notification arrive
    func copyFileToDirectory(fromPath:String, fileName:String) {
        let fileManager = NSFileManager.defaultManager()
        
        do {
            let libraryDir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.LibraryDirectory, NSSearchPathDomainMask.UserDomainMask, true)
            let directoryPath = "\(libraryDir.first!)/Sounds"
            try fileManager.createDirectoryAtPath(directoryPath, withIntermediateDirectories: true, attributes: nil)
            
            let systemSoundPath = "\(fromPath)/\(fileName)"
            let notificationSoundPath = "\(directoryPath)/notification.caf"
            
            let fileExist = fileManager.fileExistsAtPath(notificationSoundPath)
            if (fileExist) {
                try fileManager.removeItemAtPath(notificationSoundPath)
            }
            try fileManager.copyItemAtPath(systemSoundPath, toPath: notificationSoundPath)
        }
        catch let error as NSError {
            print("Error: \(error)")
        }
    }
    
    func removeTempVideo(itemName: String, fileExtension: String) {
        let fileManager = NSFileManager.defaultManager()
        let nsDocumentDirectory = NSSearchPathDirectory.DocumentDirectory
        let nsUserDomainMask = NSSearchPathDomainMask.UserDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        guard let dirPath = paths.first else {
            return
        }
        let filePath = "\(dirPath)/video/\(itemName).\(fileExtension)"
        do {
            try fileManager.removeItemAtPath(filePath)
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }
    
    func removeTempSound(itemName: String, fileExtension: String) {
        let fileManager = NSFileManager.defaultManager()
        let nsDocumentDirectory = NSSearchPathDirectory.DocumentDirectory
        let nsUserDomainMask = NSSearchPathDomainMask.UserDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        guard let dirPath = paths.first else {
            return
        }
        let filePath = "\(dirPath)/sound/\(itemName).\(fileExtension)"
        do {
            try fileManager.removeItemAtPath(filePath)
        } catch let error as NSError {
            print(error.debugDescription)
        }
    }
    
    // MARK: - soundrecordingindicator
    
    func updateSoundRecordingIndicator() {
        self.soundRecordIndicator.layer.removeAllAnimations()
        switch (self.isRecordingAudio) {
            case 0:
                self.soundRecordIndicator.image = UIImage(named: "record_gray")
            break
            case 1:
                self.soundRecordIndicator.image = UIImage(named: "record_yellow")
            break
            case 2:
                self.soundRecordIndicator.image = UIImage(named: "record_red")
                UIView.animateWithDuration(0.5, delay: 0.0, options: [UIViewAnimationOptions.Autoreverse, UIViewAnimationOptions.Repeat], animations: {
                        self.soundRecordIndicator.alpha = 0.0
                        self.soundRecordIndicator.alpha = 1.0
                    }, completion: { finished in
                        self.soundRecordIndicator.alpha = 1.0
                })
            break
            case 3:
                UIView.animateWithDuration(0.5, delay: 0.0, options: [UIViewAnimationOptions.TransitionCrossDissolve], animations: {
                        self.soundRecordIndicator.image = UIImage(named: "record_green")
                    }, completion: { finished in
                })
            break
            default:
            break
        }
    }
    
    // MARK: - oishinavigationbardelegate
    
    override func menuDidTap() {
        let menu = MenuTableViewController(nibName: "MenuTableViewController", bundle: nil)
        menu.modalPresentationStyle = .OverCurrentContext
        self.definesPresentationContext = true
        self.presentViewController(menu, animated: false, completion: nil)
    }

}
