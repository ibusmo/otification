//
//  CreateFriendTableViewController.swift
//  oishi
//
//  Created by warinporn khantithamaporn on 8/23/2559 BE.
//  Copyright © 2559 com.rollingneko. All rights reserved.
//

import UIKit

class CreateFriendTableViewController: OishiTableViewController, ActionsTableViewCellDelegate, ActorsPickerTableViewCellDelegate {

    let frontImageView = UIImageView()
    
    let actorNameLabel = UILabel()
    var sendToFriendImageView = UIImageView()
    var facebookButton = UIButton()
    var lineButton = UIButton()
    
    var action: Action = Otification.friendAlarmActions[0]
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
        
        self.tableView.bounces = false
        
        self.tableView.registerNib(UINib(nibName: "FriendActionsTableViewCell", bundle: nil), forCellReuseIdentifier: "friendActionsCell")
        self.tableView.registerNib(UINib(nibName: "FriendActorsPickerTableViewCell", bundle: nil), forCellReuseIdentifier: "friendActorsCell")
        
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        self.showBottomBarView = true
        self.tabBar.setBottomBarView("เตือนตัวเอง", rightButtonTitle: "ส่งให้เพื่อน", leftButtonSelected: false)
        
        self.backgroundImageView.frame = CGRectMake(0.0, 0.0, self.screenSize.width, self.screenSize.height)
        self.backgroundImageView.image = UIImage(named: "createfriend_bg")
        self.backgroundImageView.contentMode = UIViewContentMode.ScaleAspectFill
        
        self.initCreateFriendView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initCreateFriendView() {
        self.frontImageView.frame = CGRectMake(0.0, Otification.rHeight - Otification.calculatedHeightFromRatio(905.0), Otification.rWidth, Otification.calculatedHeightFromRatio(905.0))
        self.frontImageView.image = UIImage(named: "createfriend_front_bg")
        self.frontImageView.layer.zPosition = 750
        self.frontImageView.userInteractionEnabled = true
        
        let sendImageSize = CGSizeMake(Otification.calculatedWidthFromRatio(482.0), Otification.calculatedHeightFromRatio(113.0))
        self.sendToFriendImageView.frame = CGRectMake((Otification.rWidth - sendImageSize.width) / 2.0, Otification.calculatedHeightFromRatio(322.0), sendImageSize.width, sendImageSize.height)
        self.sendToFriendImageView.image = UIImage(named: "send_to_friend")
        
        let bubbleSize = CGSizeMake(Otification.calculatedWidthFromRatio(657.0), Otification.calculatedHeightFromRatio(286.0))
        self.actorNameLabel.frame = CGRectMake((Otification.rWidth - bubbleSize.width) / 2.0, Otification.calculatedHeightFromRatio(10.0), bubbleSize.width, bubbleSize.height)
        self.actorNameLabel.font = UIFont(name: Otification.DBHELVETHAICA_X_BOLD, size: Otification.calculatedHeightFromRatio(90.0))
        self.actorNameLabel.textColor = UIColor.blackColor()
        self.actorNameLabel.textAlignment = .Center
        
        self.actorNameLabel.text = "พุฒ พุฒิชัย"
        
        let shareButtonSize = CGSizeMake(Otification.calculatedWidthFromRatio(522.0), Otification.calculatedHeightFromRatio(185.0))
        self.facebookButton.setFrameAndImageWithShadow(CGRectMake(Otification.calculatedWidthFromRatio(86.0), Otification.calculatedHeightFromRatio(466.0), shareButtonSize.width, shareButtonSize.height), image: UIImage(named: "createfriend_fb_button"))
        self.lineButton.setFrameAndImageWithShadow(CGRectMake(Otification.calculatedWidthFromRatio(636.0), Otification.calculatedHeightFromRatio(466.0), shareButtonSize.width, shareButtonSize.height), image: UIImage(named: "createfriend_line_button"))
        
        self.view.addSubview(self.frontImageView)
        self.frontImageView.addSubview(self.actorNameLabel)
        self.frontImageView.addSubview(self.sendToFriendImageView)
        self.frontImageView.addSubview(self.facebookButton)
        self.frontImageView.addSubview(self.lineButton)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            let cell = tableView.dequeueReusableCellWithIdentifier("friendActionsCell", forIndexPath: indexPath) as! FriendActionsTableViewCell
            cell.isFriendAction = true
            cell.delegate = self
            cell.initSelectedImageView()
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("friendActorsCell", forIndexPath: indexPath) as! FriendActorsPickerTableViewCell
            cell.delegate = self
            return cell
        }
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.row == 0) {
            return Otification.calculatedHeightFromRatio(380.0)
        } else {
            return Otification.calculatedHeightFromRatio(1166.0)
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRectMake(0.0, 0.0, Otification.rWidth, Otification.calculatedHeightFromRatio(144.0)))
        view.backgroundColor = UIColor.clearColor()
        return view
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Otification.calculatedHeightFromRatio(144.0)
    }
    
    // MARK: - actionstableviewcelldelegate
    
    func didSelectAction(action: Action) {
    }
    
    // MARK: - actorstableviewcelldelegate
    
    func didPickActor(actor: Actor, active: Bool) {
        self.actorNameLabel.text = actor.actorName
    }
    
    func didSelectActor(actor: Actor, active: Bool) {
    }
    
    // MARK: - oishitabbardelegate
    
    override func leftButtonDidTap() {
        ViewControllerManager.sharedInstance.presentCreateAlarm()
    }

}
