//
//  PopupThankyouViewController.swift
//  OISHI
//
//  Created by warinporn khantithamaporn on 8/30/2559 BE.
//  Copyright © 2559 com.rollingneko. All rights reserved.
//

import UIKit

class PopupThankyouViewController: UIViewController {
    
    var backgroundImageView = UIImageView()
    var popupImageView = UIImageView()
    
    var isOnlyThankyou: Bool = true

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.clearColor()
        
        self.backgroundImageView.frame = CGRectMake(0.0, 0.0, Otification.rWidth, Otification.rHeight)
        self.backgroundImageView.image = UIImage(named: "popup_bg")
        self.backgroundImageView.layer.zPosition = 250
        
        self.view.addSubview(self.backgroundImageView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
