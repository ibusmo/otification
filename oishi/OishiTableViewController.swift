//
//  OishiTableViewController.swift
//  oishi
//
//  Created by warinporn khantithamaporn on 8/11/2559 BE.
//  Copyright © 2559 com.rollingneko. All rights reserved.
//

import UIKit

class OishiTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, OishiNavigationBarDelegate, OishiTabBarViewDelegate {
    
    var navBar: OishiNavigationBar = OishiNavigationBar()
    var tabBar: OishiTabBarView = OishiTabBarView()
    
    var tableView: UITableView = UITableView()
    var backgroundImageView: UIImageView = UIImageView()
    
    let screenSize = CGSizeMake(Otification.rWidth, Otification.rHeight)
   
    var showBottomBarView: Bool = true
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.clearColor()
        
        self.navBar.delegate = self
        self.tabBar.delegate = self
        
        self.tableView.frame = CGRectMake(0.0, Otification.navigationBarHeight, Otification.rWidth, Otification.rHeight)
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tableView.backgroundColor = UIColor.clearColor()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        self.tableView.showsVerticalScrollIndicator = false
        
        self.view.addSubview(self.backgroundImageView)
        self.view.addSubview(self.tableView)
        
        self.view.addSubview(self.navBar)
        self.view.bringSubviewToFront(self.navBar)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // MARK: - custom inset for navigation bar and bottom bar
        if (self.showBottomBarView) {
            self.tableView.frame = CGRectMake(0.0, Otification.navigationBarHeight, Otification.rWidth, Otification.rHeight - Otification.calculatedHeightFromRatio(368.0))
            self.view.addSubview(self.tabBar)
            self.view.bringSubviewToFront(self.tabBar)
        } else {
            self.tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("", forIndexPath: indexPath) 
        return cell
    }
    
    // MARK: - oishinavigationbardelegate
    
    func menuDidTap() {
        
    }
    
    // MARK: - oishitabbardelegate
    
    func leftButtonDidTap() {
    }
    
    func rightButtonDidTap() {
    }
    
    // MARK: - 

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
