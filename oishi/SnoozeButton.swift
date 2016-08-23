//
//  SnoozeButton.swift
//  OishiComponent
//
//  Created by Omsub on 8/17/2559 BE.
//  Copyright © 2559 omsubusmo. All rights reserved.
//

import UIKit

enum SnoozeState {
    case Normal, Snooze, Stop
}

protocol SnoozeButtonDelegate {
    func snoozeDidDrag(snooze: SnoozeButton)
}

class SnoozeButton: UIView {
    
    private var bar: UIImageView?
    private var button: UIButton?
    
    var delegate: SnoozeButtonDelegate?
    
    override init(frame: CGRect) {
        //  init with width
        //  bar     1236 x 315
        //  button   343 x 315
        super.init(frame: CGRectMake(frame.origin.x, frame.origin.y, frame.width, 315/1236*frame.width))
        self.initComponent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initComponent() {
        self.bar = UIImageView(frame: CGRectMake(0.0, 0.0, self.frame.width, self.frame.height))
        self.addSubview(self.bar!)
        self.bar?.backgroundColor = UIColor.clearColor()
        self.bar?.image = UIImage(named: "SnoozeBar")
        
        self.button = UIButton(frame: CGRectMake(0.0, 0.0, 343/315*self.frame.height, self.frame.height))
        self.addSubview(self.button!)
        self.button?.backgroundColor = UIColor.clearColor()
        self.button?.setImage(UIImage(named: "SnoozeButton"), forState: UIControlState.Normal)
        self.button?.setImage(UIImage(named: "SnoozeButton"), forState: UIControlState.Highlighted)
        self.button?.center = self.bar!.center
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(SnoozeButton.handleLongPress(_:)))
        longPress.minimumPressDuration = 0.01
        self.button!.addGestureRecognizer(longPress)
    }
    
    private var buttonCenter: CGPoint = CGPointZero
    private var offsetBounds: CGFloat = 5.0
    var blockSlide: Bool = false
    @objc private func handleLongPress(longPress: UILongPressGestureRecognizer) {
        print("handleLongPress: ")
        if !blockSlide {
            switch longPress.state {
            case .Began:
                self.buttonCenter = self.bar!.center
                
            case .Ended:
                
                UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                    self.button?.center.x
                    self.button?.center.x = self.buttonCenter.x
                    }, completion: nil)
                
                self.snoozeEventTrigger()
                
            case .Changed:
                
                let point = longPress.locationInView(self.bar)
                
                if (point.x < self.button!.frame.width/2+self.offsetBounds) {
                    
                    self.button?.center.x = self.button!.frame.width/2+self.offsetBounds
                    self.buttonCenter = self.button!.center
                    
                } else if (point.x > self.bar!.frame.width-self.button!.frame.width/2-self.offsetBounds) {
                    
                    self.button?.center.x = self.bar!.frame.width-self.button!.frame.width/2-self.offsetBounds
                    self.buttonCenter = self.button!.center
                    
                } else {
                    self.button?.center.x = point.x
                }
                print("point: \(point.x) \(point.y)")
                
            default:
                break
            }
        }
    }
    
    private func changeState(state: SnoozeState) {
        self.buttonCenter = self.bar!.center
        switch state {
        case .Snooze:
            self.buttonCenter.x = 0 + (self.button!.frame.width)/2 + self.offsetBounds
        case .Stop:
            self.buttonCenter.x = self.bar!.frame.width - (self.button!.frame.width/2) - self.offsetBounds
        default:
            self.buttonCenter = self.bar!.center
        }
        
        UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.button?.center.x
            self.button?.center = self.buttonCenter
            }, completion: nil)
    }
    
    private var _state: SnoozeState = .Normal
    var state: SnoozeState {
        set (newVal) {
            _state = newVal
            self.changeState(newVal)
        } get {
            return _state
        }
    }
    
    private func snoozeEventTrigger() {
        if self.button?.center.x <= self.button!.frame.width/2+self.offsetBounds {
            self.state = .Snooze
            print("snoozeEventTrigger: Snooze")
        } else if self.button?.center.x >= self.bar!.frame.width-self.button!.frame.width/2-self.offsetBounds {
            self.state = .Stop
            print("snoozeEventTrigger: Stop")
        } else {
            self.state = .Normal
            print("snoozeEventTrigger: Normal")
        }
        self.delegate?.snoozeDidDrag(self)
    }
    
}
