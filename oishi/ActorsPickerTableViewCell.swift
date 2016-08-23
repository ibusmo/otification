//
//  ActorsPickerTableViewCell.swift
//  oishi
//
//  Created by warinporn khantithamaporn on 8/18/2559 BE.
//  Copyright © 2559 com.rollingneko. All rights reserved.
//

import UIKit

protocol ActorsPickerTableViewCellDelegate {
    func didPickActor(actor: Actor)
}

class ActorsPickerTableViewCell: UITableViewCell, iCarouselDataSource, iCarouselDelegate {

    @IBOutlet weak var carousel: iCarousel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var leftButton: UIButton = UIButton()
    var rightButton: UIButton = UIButton()
    
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
        self.carousel.type = .Rotary
        
        let buttonSize = CGSizeMake(Otification.calculatedWidthFromRatio(60.0), Otification.calculatedHeightFromRatio(100.0))
        
        self.leftButton.setFrameAndImageWithShadow(CGRectMake(Otification.calculatedWidthFromRatio(32.0), (self.frame.size.height - buttonSize.height) / 2.0, buttonSize.width, buttonSize.height), image: UIImage(named: "left_button"))
        self.rightButton.setFrameAndImageWithShadow(CGRectMake(Otification.rWidth - (Otification.calculatedWidthFromRatio(32.0) + buttonSize.width), (self.frame.size.height - buttonSize.height) / 2.0, buttonSize.width, buttonSize.height), image: UIImage(named: "right_button"))
        
        self.leftButton.addTarget(self, action: #selector(ActorsPickerTableViewCell.leftButtonDidTap), forControlEvents: UIControlEvents.TouchUpInside)
        self.rightButton.addTarget(self, action: #selector(ActorsPickerTableViewCell.rightButtonDidTap), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.contentView.addSubview(self.leftButton)
        self.contentView.addSubview(self.rightButton)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - icarousel
    
    func numberOfItemsInCarousel(carousel: iCarousel) -> Int {
        return Otification.actors.count
    }
    
    func carousel(carousel: iCarousel, viewForItemAtIndex index: Int, reusingView view: UIView?) -> UIView {
        var bgView: UIView
        var actorImageView: UIImageView
        
        if (view == nil) {
            // let size = CGSizeMake(Otification.calculatedWidthFromRatio(632.0), Otification.calculatedHeightFromRatio(587.0))
            let size = CGSizeMake(Otification.calculatedWidthFromRatio(768.0), Otification.calculatedHeightFromRatio(743.0))
            
            bgView = UIView(frame: CGRectMake(0.0, 0.0, Otification.calculatedWidthFromRatio(632.0), Otification.calculatedHeightFromRatio(587.0)))
            bgView.backgroundColor = UIColor.clearColor()
            
            actorImageView = UIImageView(frame: CGRectMake(0.0, 0.0, size.width, size.height))
            actorImageView.contentMode = .ScaleAspectFit
            actorImageView.backgroundColor = UIColor.clearColor()
            
            bgView.addSubview(actorImageView)
        } else {
            bgView = view!
            actorImageView = view as! UIImageView
        }
        
        actorImageView.image = UIImage(named: "actor_0\(index + 1)")
        
        return actorImageView
    }
    
    func carousel(carousel: iCarousel, valueForOption option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if (option == .Spacing) {
            return value * 0.85
        }
        if (option == .Angle) {
            if (value < 0) {
                return value * 1.75
            } else {
                return value * 1.25
            }
        }
        return value
    }
    
    func carouselCurrentItemIndexDidChange(carousel: iCarousel) {
        // TODO: - show name
        self.delegate?.didPickActor(Otification.actors[carousel.currentItemIndex])
    }
    
    // MARK: - leftbutton & rightbutton
    
    func leftButtonDidTap() {
        self.carousel.scrollToItemAtIndex(self.carousel.currentItemIndex - 1 < 0 ? 6 : self.carousel.currentItemIndex - 1, animated: true)
    }
    
    func rightButtonDidTap() {
        self.carousel.scrollToItemAtIndex(self.carousel.currentItemIndex + 1 > 6 ? 0 : self.carousel.currentItemIndex + 1, animated: true)
    }
    
    /*
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("actorCell", forIndexPath: indexPath) as! ActorCollectionViewCell
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake((632.0 / 1242.0) * UIScreen.mainScreen().bounds.size.width, (587.0 / 2208.0) * UIScreen.mainScreen().bounds.size.height)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.0
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.collectionView.scaledVisibleCells()
    }
     */
    
}
