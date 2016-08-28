//
//  GalleryTableViewController.swift
//  oishi
//
//  Created by warinporn khantithamaporn on 8/27/2559 BE.
//  Copyright © 2559 com.rollingneko. All rights reserved.
//

import UIKit

class GalleryTableViewController: OishiTableViewController {
    
    var action: Action = Otification.selfAlarmActions[0]
    var actor: Actor = Otification.actors[0]
    var selectedActorActive: Bool = true
    
    var dictionary = Dictionary<String, [ActionInfo]>()
    var selectedActionInfo = [ActionInfo]()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.registerNib(UINib(nibName: "GalleryActorsTableViewCell", bundle: nil), forCellReuseIdentifier: "galleryActorsCell")
        self.tableView.registerNib(UINib(nibName: "VideoPreviewTableViewCell", bundle: nil), forCellReuseIdentifier: "videoPreviewCell")
        
        self.tableView.bounces = false
        
        self.backgroundImageView.frame = CGRectMake(0.0, 0.0, Otification.rWidth, Otification.rHeight)
        self.backgroundImageView.image = UIImage(named: "gallery_bg")
        self.backgroundImageView.contentMode = UIViewContentMode.ScaleAspectFill
        
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        self.showBottomBarView = false
        
        self.getPlaylistGallery()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // y = 1122
        self.tableView.frame = CGRectMake(0.0, Otification.calculatedHeightFromRatio(1080.0), self.tableView.frame.size.width, Otification.rHeight - Otification.calculatedHeightFromRatio(1080.0))
    }
    
    override func viewDidAppear(animated: Bool) {
        self.tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 100.0, 0.0)
        self.tableView.setNeedsDisplay()
    }
    
    override func viewWillLayoutSubviews() {
        // self.tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, Otification.calculatedHeightFromRatio(40.0), 0.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.selectedActionInfo.count % 2 == 1 ? (self.selectedActionInfo.count / 2) + 1 : self.selectedActionInfo.count / 2
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("videoPreviewCell", forIndexPath: indexPath) as! VideoPreviewTableViewCell
        cell.initVideoPreviewCell()
        
        let leftActionInfo = self.selectedActionInfo[indexPath.row * 2]
        cell.initLeftVideoPreview(leftActionInfo)
        
        if ((indexPath.row * 2) + 1 < self.selectedActionInfo.count) {
            let rightActionInfo = self.selectedActionInfo[(indexPath.row * 2) + 1]
            cell.initRightVideoPreview(rightActionInfo)
        }
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return Otification.calculatedHeightFromRatio(560.0)
    }
    
    // MARK: - api
    
    func getPlaylistGallery() {
        let _ = OtificationHTTPService.sharedInstance.getPlaylistGallery(Callback() { (response, success, errorString, error) in
            if let dictionary = response where success {
                self.dictionary = dictionary
                print("gallery.count: \(self.dictionary.count)")
                if let actionInfos = self.dictionary["1"] {
                    self.selectedActionInfo = actionInfos
                    self.tableView.reloadData()
                }
            }
        })   
    }
    
    // MARK: - oishinavigationbardelegate
    
    override func menuDidTap() {
        let menu = MenuTableViewController(nibName: "MenuTableViewController", bundle: nil)
        menu.modalPresentationStyle = .OverCurrentContext
        self.definesPresentationContext = true
        self.presentViewController(menu, animated: true, completion: nil)
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
