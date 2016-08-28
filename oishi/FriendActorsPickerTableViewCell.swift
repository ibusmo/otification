//
//  FriendActorsPickerTableViewCell.swift
//  oishi
//
//  Created by warinporn khantithamaporn on 8/23/2559 BE.
//  Copyright © 2559 com.rollingneko. All rights reserved.
//

import UIKit

class FriendActorsPickerTableViewCell: UITableViewCell, iCarouselDataSource, iCarouselDelegate {

    @IBOutlet weak var carousel: iCarousel!
    
    var leftButton: UIButton = UIButton()
    var rightButton: UIButton = UIButton()
    
    var active = [Bool](count: 6, repeatedValue: true)
    
    var actors = [Actor]()
    
    var delegate: ActorsPickerTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectionStyle = .None
        self.backgroundView = nil
        self.backgroundColor = UIColor.clearColor()
        
        self.carousel.dataSource = self
        self.carousel.delegate = self
        
        self.carousel.backgroundColor = UIColor.clearColor()
        self.carousel.type = .Linear
        
        let buttonSize = CGSizeMake(Otification.calculatedWidthFromRatio(60.0), Otification.calculatedHeightFromRatio(100.0))
        
        self.leftButton.setFrameAndImageWithShadow(CGRectMake(Otification.calculatedWidthFromRatio(32.0), Otification.calculatedHeightFromRatio(300.0), buttonSize.width, buttonSize.height), image: UIImage(named: "left_button"))
        self.rightButton.setFrameAndImageWithShadow(CGRectMake(Otification.rWidth - (Otification.calculatedWidthFromRatio(32.0) + buttonSize.width), Otification.calculatedHeightFromRatio(300.0), buttonSize.width, buttonSize.height), image: UIImage(named: "right_button"))
        
        self.leftButton.addTarget(self, action: #selector(ActorsPickerTableViewCell.leftButtonDidTap), forControlEvents: UIControlEvents.TouchUpInside)
        self.rightButton.addTarget(self, action: #selector(ActorsPickerTableViewCell.rightButtonDidTap), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.contentView.addSubview(self.leftButton)
        self.contentView.addSubview(self.rightButton)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setActors(ids: [String]) {
        self.actors.removeAll(keepCapacity: false)
        for id in ids {
            self.actors.append(Otification.actors[Int(id)! - 1])
        }
        self.carousel.reloadData()
    }
    
    // MARK: - icarousel
    
    func numberOfItemsInCarousel(carousel: iCarousel) -> Int {
        return self.actors.count
    }
    
    func carousel(carousel: iCarousel, viewForItemAtIndex index: Int, reusingView view: UIView?) -> UIView {
        var bgView: UIView
        var actorImageView: UIImageView
        let actor = self.actors[index]
        
        if (view == nil) {
            // let size = CGSizeMake(Otification.calculatedWidthFromRatio(632.0), Otification.calculatedHeightFromRatio(587.0))
            let size = CGSizeMake(Otification.calculatedWidthFromRatio(811.0), Otification.calculatedHeightFromRatio(1110.0))
            
            bgView = UIView(frame: CGRectMake(0.0, 0.0, Otification.calculatedWidthFromRatio(768.0), Otification.calculatedHeightFromRatio(743.0)))
            bgView.backgroundColor = UIColor.clearColor()
            
            actorImageView = UIImageView(frame: CGRectMake(0.0, 0.0, size.width, size.height))
            actorImageView.contentMode = .ScaleAspectFit
            actorImageView.backgroundColor = UIColor.clearColor()
            
            bgView.addSubview(actorImageView)
        } else {
            bgView = view!
            actorImageView = view as! UIImageView
        }
        
        if (self.active[index]) {
            actorImageView.alpha = 1.0
        } else {
            actorImageView.alpha = 0.5
        }
        
        actorImageView.image = UIImage(named: "full_actor_0\(actor.name!)")
        
        return actorImageView
    }
    
    func carousel(carousel: iCarousel, valueForOption option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if (option == .Spacing) {
            return value * 0.85
        }
        if (option == .Wrap) {
            return 1.0
        }
        if (option == .VisibleItems) {
            return 1.0
        }
        return value
    }
    
    func carouselCurrentItemIndexDidChange(carousel: iCarousel) {
        // TODO: - show name
        if (self.actors.count > 0) {
            self.delegate?.didPickActor(self.actors[carousel.currentItemIndex], active: self.active[carousel.currentItemIndex])
        }
    }
    
    func carousel(carousel: iCarousel, didSelectItemAtIndex index: Int) {
        print("didSelectItemAtIndex: \(index)")
        self.delegate?.didSelectActor(self.actors[index], active: self.active[index])
    }
    
    // MARK: - leftbutton & rightbutton
    
    func leftButtonDidTap() {
        self.carousel.scrollToItemAtIndex(self.carousel.currentItemIndex - 1 < 0 ? 6 : self.carousel.currentItemIndex - 1, animated: true)
    }
    
    func rightButtonDidTap() {
        self.carousel.scrollToItemAtIndex(self.carousel.currentItemIndex + 1 > 6 ? 0 : self.carousel.currentItemIndex + 1, animated: true)
    }
    
}
