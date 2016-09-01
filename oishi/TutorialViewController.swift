//
//  TutorialViewController.swift
//  oishi
//
//  Created by warinporn khantithamaporn on 8/23/2559 BE.
//  Copyright © 2559 com.rollingneko. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class TutorialViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var closeButton = UIButton()
    
    var numberOfTutorial: Int = 6
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.clipsToBounds = true
        self.view.backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.5)
        
        self.collectionView.frame = CGRectMake(0.0, 0.0, Otification.rWidth, Otification.rHeight)
        self.collectionView.backgroundColor = UIColor.blueColor().colorWithAlphaComponent(0.5)
        
        // Do any additional setup after loading the view.
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        self.collectionView.clipsToBounds = true
        
        self.collectionView.registerNib(UINib(nibName: "TutorialCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "tutorialCell")
        
        self.closeButton.frame = CGRectMake(Otification.calculatedWidthFromRatio(1000.0), Otification.calculatedHeightFromRatio(50.0), Otification.calculatedWidthFromRatio(193.0), Otification.calculatedHeightFromRatio(196.0))
        self.closeButton.setImage(UIImage(named: "tutorial_close_button"), forState: UIControlState.Normal)
        self.closeButton.addTarget(self, action: #selector(TutorialViewController.closeDidTap), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(self.closeButton)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.view.frame = CGRectMake(0.0, 0.0, Otification.rWidth, Otification.rHeight)
        self.collectionView.frame = CGRectMake(0.0, 0.0, Otification.rWidth, Otification.rHeight)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.numberOfTutorial
        /*
        let defaults = NSUserDefaults.standardUserDefaults()
        if let bool: Bool = defaults.boolForKey("first_tutorial") where bool {
            return 6
        } else {
            return 2
        }
         */
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("tutorialCell", forIndexPath: indexPath) as! TutorialCollectionViewCell
        cell.initTutorialCell()
        cell.tutorialImageView.image = UIImage(named: "tutorial_\(indexPath.row + 1)")
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(Otification.rWidth, Otification.rHeight)
    }
    
    // MARK: - closbutton
    
    func closeDidTap() {
        OtificationGoogleAnalytics.sharedInstance.sendGoogleAnalyticsEventTracking(.Button, action: .Clicked, label: "tutorial_close")
        let defaults = NSUserDefaults.standardUserDefaults()
        if let bool: Bool = defaults.boolForKey("first_tutorial") where bool {
            ViewControllerManager.sharedInstance.presentMyList()
        } else {
            defaults.setBool(true, forKey: "first_tutorial")
            ViewControllerManager.sharedInstance.presentCreateAlarm()
        }
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
