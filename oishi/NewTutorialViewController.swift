//
//  NewTutorialViewController.swift
//  OISHI
//
//  Created by warinporn khantithamaporn on 9/3/2559 BE.
//  Copyright © 2559 com.rollingneko. All rights reserved.
//

import UIKit

class NewTutorialViewController: UIViewController, iCarouselDataSource, iCarouselDelegate {
    
    var backgroundImageView = UIImageView()
    var carousel = iCarousel()
    var shadowView = UIView()
    var closeButton = UIButton()
    
    var tutorialLabel = UILabel()
    var pagingIndicators = [UIImageView]()
    var leftButton = UIButton()
    var rightButton = UIButton()
    
    var numberOfTutorial: Int = 6
    var tutorialTitle = [
        "หน้าตั้งเตือนตัวเอง",
        "Slide ข้อความเตือนเพื่อดูวีดีโอ",
        "หน้าสร้างวีดีโอเอง",
        "หน้าส่งให้เพื่อน",
        "หน้าจัดการ list",
        "หน้าตั้งค่าการเตือน"
    ]
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.clipsToBounds = true
        self.view.backgroundColor = UIColor.clearColor()
        
        self.backgroundImageView.frame = CGRectMake(0.0, 0.0, Otification.rWidth, Otification.rHeight)
        self.backgroundImageView.backgroundColor = UIColor.clearColor()
        self.backgroundImageView.image = UIImage(named: "new_tutorial_bg")
        
        self.view.addSubview(self.backgroundImageView)
        
        self.closeButton.frame = CGRectMake(Otification.calculatedWidthFromRatio(1000.0), Otification.calculatedHeightFromRatio(50.0), Otification.calculatedWidthFromRatio(193.0), Otification.calculatedHeightFromRatio(196.0))
        self.closeButton.setImage(UIImage(named: "tutorial_close_button"), forState: UIControlState.Normal)
        self.closeButton.addTarget(self, action: #selector(TutorialViewController.closeDidTap), forControlEvents: UIControlEvents.TouchUpInside)
        
        // icarousel
        
        self.carousel.dataSource = self
        self.carousel.delegate = self
        
        self.carousel.frame = CGRectMake(Otification.calculatedWidthFromRatio(109.0), Otification.calculatedHeightFromRatio(88.0), Otification.calculatedWidthFromRatio(1024.0), Otification.calculatedHeightFromRatio(1820.0))
        
        self.carousel.backgroundColor = UIColor.clearColor()
        self.carousel.type = .Linear
        self.carousel.bounces = false
        self.carousel.clipsToBounds = true
        
        self.shadowView.frame = CGRectMake(Otification.calculatedWidthFromRatio(109.0), Otification.calculatedHeightFromRatio(90.0), Otification.calculatedWidthFromRatio(1020.0), Otification.calculatedHeightFromRatio(1815.0))
        self.shadowView.backgroundColor = UIColor.whiteColor()
        self.shadowView.layer.shadowColor = UIColor.blackColor().CGColor
        self.shadowView.layer.shadowOffset = CGSizeMake(5.0, 5.0)
        self.shadowView.layer.shadowRadius = 5.0
        self.shadowView.layer.shadowOpacity = 0.5
        
        self.view.addSubview(self.shadowView)
        self.view.addSubview(self.carousel)
        
        self.view.addSubview(self.closeButton)
        
        let buttonSize = CGSizeMake(Otification.calculatedWidthFromRatio(60.0), Otification.calculatedHeightFromRatio(100.0))
        var x: CGFloat = self.numberOfTutorial <= 2 ? (Otification.rWidth - Otification.calculatedWidthFromRatio(145.0)) / 2.0 : (Otification.rWidth - Otification.calculatedWidthFromRatio(537.0)) / 2.0
        
        self.leftButton.setFrameAndImageWithShadow(CGRectMake(x - Otification.calculatedWidthFromRatio(118.0), Otification.calculatedHeightFromRatio(2038.0), buttonSize.width, buttonSize.height), image: UIImage(named: "left_button"))
        
        for i in 0 ..< self.numberOfTutorial {
            print("x: \(x)")
            let imageView = UIImageView()
            imageView.frame = CGRectMake(x, Otification.calculatedHeightFromRatio(2065.0), Otification.calculatedWidthFromRatio(48.0), Otification.calculatedHeightFromRatio(47.0))
            imageView.image = UIImage(named: "tutorial_indicator")
            self.pagingIndicators.append(imageView)
            self.view.addSubview(self.pagingIndicators[i])
            if (i != self.numberOfTutorial - 1) {
                x += Otification.calculatedWidthFromRatio(48.0 + 51.0)
            }
        }
        self.pagingIndicators[0].image = UIImage(named: "tutorial_indicator_selected")
        
        self.rightButton.setFrameAndImageWithShadow(CGRectMake(x + (Otification.calculatedWidthFromRatio(110.0)), Otification.calculatedHeightFromRatio(2038.0), buttonSize.width, buttonSize.height), image: UIImage(named: "right_button"))
        
        self.leftButton.addTarget(self, action: #selector(NewTutorialViewController.leftButtonDidTap), forControlEvents: UIControlEvents.TouchUpInside)
        self.rightButton.addTarget(self, action: #selector(NewTutorialViewController.rightButtonDidTap), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.tutorialLabel.frame = CGRectMake(0.0, Otification.calculatedHeightFromRatio(1912.0), Otification.rWidth, Otification.calculatedHeightFromRatio(180.0))
        self.tutorialLabel.textAlignment = .Center
        self.tutorialLabel.textColor = UIColor.whiteColor()
        self.tutorialLabel.text = self.tutorialTitle[0]
        self.tutorialLabel.font = UIFont(name: Otification.DBHELVETHAICAMON_X_BOLD, size: Otification.calculatedHeightFromRatio(110.0))
        self.tutorialLabel.backgroundColor = UIColor.clearColor()
        self.tutorialLabel.layer.shadowColor = UIColor.blackColor().CGColor
        self.tutorialLabel.layer.shadowOffset = CGSizeMake(2.0, 2.0)
        self.tutorialLabel.layer.shadowRadius = 2.0
        self.tutorialLabel.layer.shadowOpacity = 0.3
        
        self.view.addSubview(self.tutorialLabel)
        
        self.view.addSubview(self.leftButton)
        self.view.addSubview(self.rightButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - icarousel
    
    func numberOfItemsInCarousel(carousel: iCarousel) -> Int {
        return self.numberOfTutorial
    }
    
    func carousel(carousel: iCarousel, viewForItemAtIndex index: Int, reusingView view: UIView?) -> UIView {
        
        var imageView: UIImageView
        
        if (view == nil) {
            // 269, 342
            let cellSize = CGSizeMake(Otification.calculatedWidthFromRatio(1024.0), Otification.calculatedWidthFromRatio(1820.0))
            imageView = UIImageView(frame: CGRectMake(0.0, 0.0, cellSize.width, cellSize.height))
            imageView.backgroundColor = UIColor.clearColor()
        } else {
            imageView = view as! UIImageView
        }
        
        imageView.image = UIImage(named: "tutorial_\(index + 1)")
        
        return imageView
    }
    
    func carousel(carousel: iCarousel, valueForOption option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if (option == .Spacing) {
            return value * 1.0
        }
        return value
    }
    
    func carouselCurrentItemIndexDidChange(carousel: iCarousel) {
        // TODO: - show name
        let index = carousel.currentItemIndex
        for i in 0 ..< self.pagingIndicators.count {
            self.pagingIndicators[i].image = UIImage(named: "tutorial_indicator")
        }
        self.pagingIndicators[index].image = UIImage(named: "tutorial_indicator_selected")
        self.tutorialLabel.text = self.tutorialTitle[index]
    }
    
    func carouselDidEndScrollingAnimation(carousel: iCarousel) {
    }
    
    func carouselDidScroll(carousel: iCarousel) {
    }
    
    func carouselDidEndDecelerating(carousel: iCarousel) {
    }
    
    // MARK: - controlbuttons
    
    func leftButtonDidTap() {
        let index = self.carousel.currentItemIndex
        if (index > 0) {
            OtificationGoogleAnalytics.sharedInstance.sendGoogleAnalyticsEventTracking(.Button, action: .Clicked, label: "tutorial_back")
            self.carousel.scrollToItemAtIndex(index - 1, animated: true)
        }
    }
    
    func rightButtonDidTap() {
        let index = self.carousel.currentItemIndex
        if (index < self.numberOfTutorial - 1) {
            OtificationGoogleAnalytics.sharedInstance.sendGoogleAnalyticsEventTracking(.Button, action: .Clicked, label: "tutorial_next")
            self.carousel.scrollToItemAtIndex(index + 1, animated: true)
        }
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
