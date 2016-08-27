//
//  OishiViewController.swift
//  oishi
//
//  Created by warinporn khantithamaporn on 8/23/2559 BE.
//  Copyright © 2559 com.rollingneko. All rights reserved.
//

import UIKit

class OishiViewController: UIViewController, OishiNavigationBarDelegate, OishiTabBarViewDelegate {

    var navBar: OishiNavigationBar = OishiNavigationBar()
    var tabBar: OishiTabBarView = OishiTabBarView()
    var backgroundImageView: UIImageView = UIImageView()
    
    var showBottomBarView: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.clearColor()
        
        self.navBar.delegate = self
        self.tabBar.delegate = self
        
        self.view.addSubview(self.backgroundImageView)
        
        self.view.addSubview(self.navBar)
        self.view.bringSubviewToFront(self.navBar)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // MARK: - custom inset for navigation bar and bottom bar
        if (self.showBottomBarView) {
            self.view.addSubview(self.tabBar)
            self.view.bringSubviewToFront(self.tabBar)
        } 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - oishinavigationbardelegate
    
    func menuDidTap() {
    }
    
    // MARK: - oishitabbardelegate
    
    func leftButtonDidTap() {
    }
    
    func rightButtonDidTap() {
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
