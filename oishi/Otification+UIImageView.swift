//
//  Otification+UIImageView.swift
//  oishi
//
//  Created by warinporn khantithamaporn on 8/28/2559 BE.
//  Copyright © 2559 com.rollingneko. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

extension UIImageView {

    func setImageWithProgressIndicatorAndURL(url: NSURL?, placeholderImage: UIImage?) {
        
        self.image = placeholderImage
        
        let resource = Resource(downloadURL: url!)
        
        self.kf_setImageWithResource(resource, placeholderImage: placeholderImage, optionsInfo: nil,
            progressBlock: { (receivedSize, totalSize) -> () in
                dispatch_async(dispatch_get_main_queue(), {
                })
            } , completionHandler: { (image, error, cacheType, imageURL) -> () in
                if let image = image {
                    self.image = image
                } else {
                    
                }
            }
        )
        
    }

}
