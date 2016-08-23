//
//  CustomAlarmViewController.swift
//  oishi
//
//  Created by warinporn khantithamaporn on 8/23/2559 BE.
//  Copyright © 2559 com.rollingneko. All rights reserved.
//

import UIKit

class CustomAlarmViewController: OishiViewController {
    
    var soundRecordTitle = UIImageView()
    var soundRecordButton = UIButton()
    var soundPlaybackButton = UIButton()
    
    var vdoRecordTitle = UIImageView()
    var vdoRecordButton = UIButton()
    
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initCustomAlarm() {
        let soundTitleSize = CGSizeMake(Otification.calculatedWidthFromRatio(853.0), Otification.calculatedHeightFromRatio(137.0))
        self.soundRecordTitle.frame = CGRectMake((Otification.rWidth - soundTitleSize.width) / 2.0, Otification.calculatedHeightFromRatio(280.0), soundTitleSize.width, soundTitleSize.height)
        self.soundRecordTitle.image = UIImage(named: "sound_record_title")
        
        let soundButtonSize = CGSizeMake(Otification.calculatedWidthFromRatio(239.0), Otification.calculatedHeightFromRatio(243.0))
        self.soundRecordButton.frame = CGRectMake(Otification.calculatedWidthFromRatio(356.0), Otification.calculatedHeightFromRatio(208.0 + 240.0), soundButtonSize.width, soundButtonSize.height)
        self.soundRecordButton.setImage(UIImage(named: "sound_record_button"), forState: UIControlState.Normal)
        
        self.soundPlaybackButton.frame = CGRectMake(Otification.calculatedWidthFromRatio(650.0), Otification.calculatedHeightFromRatio(208.0 + 240.0), soundButtonSize.width, soundButtonSize.height)
        self.soundPlaybackButton.setImage(UIImage(named: "sound_playback_button"), forState: UIControlState.Normal)
        
        self.view.addSubview(self.soundRecordTitle)
        self.view.addSubview(self.soundRecordButton)
        self.view.addSubview(self.soundPlaybackButton)
        
        let vdoTitleSize = CGSizeMake(Otification.calculatedWidthFromRatio(318.0), Otification.calculatedHeightFromRatio(95.0))
        self.vdoRecordTitle.frame = CGRectMake((Otification.rWidth - vdoTitleSize.width) / 2.0, Otification.calculatedHeightFromRatio(208.0 + 616.0), vdoTitleSize.width, vdoTitleSize.height)
        self.vdoRecordTitle.image = UIImage(named: "vdo_record_title")
        
        let vdoRecordButtonSize = CGSizeMake(Otification.calculatedWidthFromRatio(625.0), Otification.calculatedHeightFromRatio(215.0))
        self.vdoRecordButton.frame = CGRectMake((Otification.rWidth - vdoRecordButtonSize.width) / 2.0, Otification.calculatedHeightFromRatio(208.0 + 1580.0), vdoRecordButtonSize.width, vdoRecordButtonSize.height)
        self.vdoRecordButton.setImage(UIImage(named: "vdo_record_button"), forState: UIControlState.Normal)
        
        self.view.addSubview(self.vdoRecordTitle)
        self.view.addSubview(self.vdoRecordButton)
    }
    
    override func leftButtonDidTap() {
        ViewControllerManager.sharedInstance.presentCreateAlarm()
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
