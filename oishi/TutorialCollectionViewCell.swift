//
//  TutorialCollectionViewCell.swift
//  oishi
//
//  Created by warinporn khantithamaporn on 8/23/2559 BE.
//  Copyright © 2559 com.rollingneko. All rights reserved.
//

import UIKit

class TutorialCollectionViewCell: UICollectionViewCell {

    var tutorialImageView = UIImageView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func initTutorialCell() {
        self.tutorialImageView.frame = CGRectMake(0.0, 0.0, Otification.rWidth, Otification.rHeight)
        self.contentView.addSubview(self.tutorialImageView)
    }

}
