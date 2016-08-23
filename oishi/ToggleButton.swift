//
//  ToggleButton.swift
//  OishiComponent
//
//  Created by Omsub on 8/16/2559 BE.
//  Copyright © 2559 omsubusmo. All rights reserved.
//

import UIKit

protocol ToggleButtonDelegate {
    func toggleButtonDidTap(toggleButton: ToggleButton)
}

class ToggleButton: UIView {
    
    var delegate: ToggleButtonDelegate?
    
    var onImage: UIImage!
    var offImage: UIImage!
    
    private var button: UIButton?
    
    override init(frame: CGRect) {
        //  init with height
        //  318 x 183
        super.init(frame: CGRectMake(frame.origin.x, frame.origin.y, frame.width, frame.height))
        
        // self.initComponent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var _state: Bool = false
    var state: Bool {
        set (newVal) {
            _state = newVal
            changeState(state)
        }
        get {
            return _state
        }
    }
    
    private func initComponent() {
        self.button = UIButton(frame: CGRectMake(0.0, 0.0, self.frame.width, self.frame.height))
        self.addSubview(self.button!)
        self.button?.backgroundColor = UIColor.clearColor()
        self.button?.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        
        self.button?.addTarget(self, action: #selector(ToggleButton.toggle), forControlEvents: UIControlEvents.TouchUpInside)
        self.changeState(self.state)
    }
    
    func initComponent(onImage: UIImage, offImage: UIImage) {
        self.button = UIButton(frame: CGRectMake(0.0, 0.0, self.frame.width, self.frame.height))
        self.addSubview(self.button!)
        self.button?.backgroundColor = UIColor.clearColor()
        self.button?.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        
        self.onImage = onImage
        self.offImage = offImage
        
        self.button?.addTarget(self, action: #selector(ToggleButton.toggle), forControlEvents: UIControlEvents.TouchUpInside)
        self.changeState(self.state)
    }
    
    @objc private func toggle() {
        self.state = !self.state
        self.delegate?.toggleButtonDidTap(self)
    }
    
    private func changeState(state: Bool) {
        if state {
            self.button?.setImage(self.onImage, forState: UIControlState.Normal)
            self.button?.setImage(self.onImage, forState: UIControlState.Highlighted)
        } else {
            self.button?.setImage(self.offImage, forState: UIControlState.Normal)
            self.button?.setImage(self.offImage, forState: UIControlState.Highlighted)
        }
    }
    
}