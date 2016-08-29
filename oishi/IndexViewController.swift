//
//  IndexViewController.swift
//  oishi
//
//  Created by warinporn khantithamaporn on 8/29/2559 BE.
//  Copyright © 2559 com.rollingneko. All rights reserved.
//

import UIKit
import SystemConfiguration

class IndexViewController: UIViewController {
    
    var backgroundImageView = UIImageView()
    var button = UIButton()
    
    var timer = NSTimer()
    var counter: Int = 0
    var isLoadedData: Bool = false
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.clearColor()
        self.backgroundImageView.backgroundColor = UIColor.clearColor()
        
        self.view.clipsToBounds = true
        self.backgroundImageView.clipsToBounds = true

        // Do any additional setup after loading the view.
        self.backgroundImageView.frame = CGRectMake(0.0, 0.0, Otification.rWidth, Otification.rHeight)
        self.backgroundImageView.image = UIImage(named: "index")
        
        self.button.frame = CGRectMake(0.0, 0.0, Otification.rWidth, Otification.rHeight)
        self.button.addTarget(self, action: #selector(IndexViewController.skipIndex), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(self.backgroundImageView)
        self.view.addSubview(self.button)
       
        if (Reachability.isConnectedToNetwork()) {
            self.getDataInfo()
        } else {
            // TODO: - popup
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func skipIndex() {
        // TODO: - goto tutorial or mylist
        if (self.isLoadedData) {
            self.timer.invalidate()
            let defaults = NSUserDefaults.standardUserDefaults()
            if let bool: Bool = defaults.boolForKey("first_launch") where bool {
                ViewControllerManager.sharedInstance.presentMyList()
            } else {
                defaults.setBool(true, forKey: "first_launch")
                ViewControllerManager.sharedInstance.presentTutorial()
            }
        } else {
            if (Reachability.isConnectedToNetwork()) {
                self.timer.invalidate()
                self.getDataInfo()
            } else {
                // TODO: - popup
            }
        }
    }
    
    func getDataInfo() {
        self.timer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: #selector(IndexViewController.skipIndex), userInfo: nil, repeats: false)
        OtificationHTTPService.sharedInstance.getDataInfo(Callback() { (result, success, errorString, error) in
            if (success) {
                self.isLoadedData = true
            }
        })
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
