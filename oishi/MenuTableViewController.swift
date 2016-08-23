//
//  MenuTableViewController.swift
//  oishi
//
//  Created by warinporn khantithamaporn on 8/19/2559 BE.
//  Copyright © 2559 com.rollingneko. All rights reserved.
//

import UIKit

class MenuTableViewController: OishiTableViewController {
    
    var bottomGreenTeaImageView: UIImageView = UIImageView()
    
    let menu: [String] = ["สร้างการเตือน", "รายการตั้งเตือน", "วิธีการเล่น", "แกลลอรี่", "แชร์"]
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.bounces = false
        self.tableView.backgroundColor = UIColor(hexString: "162915")?.colorWithAlphaComponent(0.95)
        
        self.tableView.registerNib(UINib(nibName: "MenuTableViewCell", bundle: nil), forCellReuseIdentifier: "menuCell")
        
        self.navBar.menuImageView.image = UIImage(named: "close")
        
        self.backgroundImageView.image = nil
        self.backgroundImageView.backgroundColor = UIColor.clearColor()
        
        self.showBottomBarView = false
        
        let bottomGreenTeaSize = CGSizeMake(Otification.calculatedWidthFromRatio(587.0), Otification.calculatedHeightFromRatio(298.0))
        self.bottomGreenTeaImageView.frame = CGRectMake(self.screenSize.width - bottomGreenTeaSize.width, self.screenSize.height - bottomGreenTeaSize.height, bottomGreenTeaSize.width, bottomGreenTeaSize.height)
        self.bottomGreenTeaImageView.image = UIImage(named: "menu_greentea")
        self.bottomGreenTeaImageView.layer.zPosition = 1000
        
        self.view.addSubview(bottomGreenTeaImageView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func menuDidTap() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menu.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("menuCell", forIndexPath: indexPath) as! MenuTableViewCell
        cell.initMenuCell(indexPath.row == self.menu.count - 1, title: self.menu[indexPath.row])
        if (indexPath.row == self.menu.count - 1) {
            cell.initShareButtons()
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.dismissViewControllerAnimated(true, completion: nil)
        if (indexPath.row == 0) {
            if !(self.presentingViewController is CreateAlarmTableViewController) {
                ViewControllerManager.sharedInstance.presentCreateAlarm()
            }
        } else if (indexPath.row == 1) {
            ViewControllerManager.sharedInstance.presentMyList()
        } else if (indexPath.row == 2) {
            ViewControllerManager.sharedInstance.presentTutorial()
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return Otification.calculatedHeightFromRatio(234.0)
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView(frame: CGRectZero)
    }
   
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Otification.calculatedHeightFromRatio(322.0)
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
