//
//  GalleryActorsPickerView.swift
//  oishi
//
//  Created by warinporn khantithamaporn on 8/28/2559 BE.
//  Copyright © 2559 com.rollingneko. All rights reserved.
//

import UIKit

class GalleryActorsPickerView: UIView, iCarouselDataSource, iCarouselDelegate {
    
    var selectedImageView = UIImageView()       // z = 750, 360x360
    var selectedActiveImageView = UIImageView()       // z = 750, 360x360
    
    var carousel = iCarousel(frame: CGRectMake(0.0, 0.0, Otification.rWidth, Otification.calculatedHeightFromRatio(360.0)))
    
    var active = [Bool](count: 6, repeatedValue: true)
    
    var delegate: ActorsPickerTableViewCellDelegate?

    override init(frame: CGRect) {
        super.init(frame: CGRectMake(0.0, Otification.calculatedHeightFromRatio(208.0 + 286.0), Otification.rWidth, Otification.calculatedHeightFromRatio(360.0)))
        self.addSubview(self.carousel)
        
        self.carousel.dataSource = self
        self.carousel.delegate = self
        self.carousel.clipsToBounds = true
        
        let size = CGSizeMake(Otification.calculatedWidthFromRatio(345.0), Otification.calculatedHeightFromRatio(360.0))
        self.selectedImageView.frame = CGRectMake((Otification.rWidth - size.width) / 2.0,  Otification.calculatedHeightFromRatio(8.0), size.width, size.height)
        self.selectedImageView.image = UIImage(named: "gallery_selected_actor")
        self.selectedImageView.layer.zPosition = -500
        
        self.addSubview(self.selectedImageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - icarousel
    
    func numberOfItemsInCarousel(carousel: iCarousel) -> Int {
        return Otification.actors.count
    }
    
    func carousel(carousel: iCarousel, viewForItemAtIndex index: Int, reusingView view: UIView?) -> UIView {
        var galleryActor: GalleryActorView
        
        if (view == nil) {
            // let size = CGSizeMake(Otification.calculatedWidthFromRatio(632.0), Otification.calculatedHeightFromRatio(587.0))
            let size = CGSizeMake(Otification.calculatedWidthFromRatio(319.0), Otification.calculatedHeightFromRatio(319.0))
            
            galleryActor = GalleryActorView(frame: CGRectMake(Otification.calculatedWidthFromRatio(14.0), Otification.calculatedHeightFromRatio(0.0), size.width, size.height))
            
        } else {
            galleryActor = view as! GalleryActorView
        }
        
        if (self.active[index]) {
            galleryActor.actorImage.alpha = 1.0
        } else {
            galleryActor.actorImage.alpha = 0.5
        }
        
        galleryActor.actorImage.image = UIImage(named: "actorc_\(index + 1)")
        
        return galleryActor
    }
    
    func carousel(carousel: iCarousel, valueForOption option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if (option == .Spacing) {
            return value * 1.15
        }
        if (option == .Angle) {
            if (value < 0) {
                return value * 1.75
            } else {
                return value * 1.25
            }
        }
        if (option == .Wrap) {
            return 1.0
        }
        return value
    }
    
    func carouselCurrentItemIndexDidChange(carousel: iCarousel) {
        // TODO: - show name
        self.delegate?.didPickActor(Otification.actors[carousel.currentItemIndex], active: self.active[carousel.currentItemIndex])
    }
    
    func carousel(carousel: iCarousel, didSelectItemAtIndex index: Int) {
        print("didSelectItemAtIndex: \(index)")
        self.delegate?.didSelectActor(Otification.actors[index], active: self.active[index])
    }
    
    func carouselDidEndScrollingAnimation(carousel: iCarousel) {
        let galleryActor = carousel.currentItemView as! GalleryActorView
        self.selectedImageView.alpha = 0.0
        galleryActor.selectedBackground.alpha = 0.0
        UIView.animateWithDuration(0.2, animations: {
            self.selectedImageView.alpha = 0.0
            galleryActor.selectedBackground.alpha = 0.0
            self.selectedImageView.alpha = 1.0
            galleryActor.selectedBackground.alpha = 1.0
        })
    }
    
    func carouselDidScroll(carousel: iCarousel) {
        let galleryActor = carousel.currentItemView as! GalleryActorView
        UIView.animateWithDuration(0.05, animations: {
            galleryActor.selectedBackground.alpha = 0.0
            self.selectedImageView.alpha = 0.0
        })
    }
    
    // MARK: - leftbutton & rightbutton
    
    func leftButtonDidTap() {
        self.carousel.scrollToItemAtIndex(self.carousel.currentItemIndex - 1 < 0 ? 6 : self.carousel.currentItemIndex - 1, animated: true)
    }
    
    func rightButtonDidTap() {
        self.carousel.scrollToItemAtIndex(self.carousel.currentItemIndex + 1 > 6 ? 0 : self.carousel.currentItemIndex + 1, animated: true)
    }

}
