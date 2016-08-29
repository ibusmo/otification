//
//  MenuTableViewCell.swift
//  oishi
//
//  Created by warinporn khantithamaporn on 8/19/2559 BE.
//  Copyright © 2559 com.rollingneko. All rights reserved.
//

import UIKit

protocol MenuTableViewCellDelegate {
    func shareFBDidTap()
    func shareLineDidTap()
}

class MenuTableViewCell: UITableViewCell {
    
    var topSeparator: UIView = UIView()
    var bottomSeparator: UIView = UIView()
    
    var menuLabel: UILabel = UILabel()
    
    var fbButton: UIButton = UIButton()
    var lineButton: UIButton = UIButton()
    
    var delegate: MenuTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .None
        self.backgroundView = nil
        self.backgroundColor = UIColor.clearColor()
        self.contentView.backgroundColor = UIColor.clearColor()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initMenuCell(isBottom: Bool, title: String) {
        let screenSize = CGSizeMake(Otification.rWidth, Otification.rHeight)
        
        self.topSeparator.frame = CGRectMake(Otification.calculatedWidthFromRatio(62.0), 0.0, screenSize.width - (2 * Otification.calculatedWidthFromRatio(62.0)), 1.0)
        self.topSeparator.backgroundColor = UIColor(hexString: "318304")
        self.contentView.addSubview(self.topSeparator)
        
        if (isBottom) {
            self.bottomSeparator.frame = CGRectMake(Otification.calculatedWidthFromRatio(62.0), self.frame.size.height - 1.0, screenSize.width - (2 * Otification.calculatedWidthFromRatio(62.0)), 1.0)
            self.bottomSeparator.backgroundColor = UIColor(hexString: "318304")
            self.contentView.addSubview(self.bottomSeparator)
        }
        
        self.menuLabel.frame = CGRectMake(Otification.calculatedWidthFromRatio(110.0), Otification.calculatedHeightFromRatio(25.0), screenSize.width - Otification.calculatedWidthFromRatio(220.0), self.frame.size.height)
        self.menuLabel.font = UIFont(name: Otification.DBHELVETHAICAMON_X_BOLD, size: Otification.calculatedHeightFromRatio(150.0))
        self.menuLabel.textColor = UIColor.whiteColor()
        self.menuLabel.text = title
        
        self.contentView.addSubview(self.menuLabel)
    }
    
    func initShareButtons() {
        let screenSize = CGSizeMake(Otification.rWidth, Otification.rHeight)
        let buttonSize = CGSizeMake(Otification.calculatedWidthFromRatio(162.0), Otification.calculatedHeightFromRatio(162.0))
        
        self.fbButton.setFrameAndImageWithShadow(CGRectMake(screenSize.width - Otification.calculatedWidthFromRatio(424.0), (self.frame.size.height - buttonSize.height) / 2.0, buttonSize.width, buttonSize.height), image: UIImage(named: "share_fb"))
        self.fbButton.addTarget(self, action: #selector(MenuTableViewCell.fbDidTap), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.lineButton.setFrameAndImageWithShadow(CGRectMake(screenSize.width - Otification.calculatedWidthFromRatio(234.0), (self.frame.size.height - buttonSize.height) / 2.0, buttonSize.width, buttonSize.height), image: UIImage(named: "share_line"))
        self.lineButton.addTarget(self, action: #selector(MenuTableViewCell.lineDidTap), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.contentView.addSubview(self.fbButton)
        self.contentView.addSubview(self.lineButton)
    }
    
    func fbDidTap() {
        self.delegate?.shareFBDidTap()
    }
    
    func lineDidTap() {
        self.delegate?.shareLineDidTap()
    }
    
}
