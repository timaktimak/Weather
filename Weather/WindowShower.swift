//
//  Window.swift
//  Boost
//
//  Created by Timur Galimov on 30/05/15.
//  Copyright (c) 2015 Timur Galimov. All rights reserved.
//

import Foundation
import UIKit

enum WindowShowAnimation {
    case SlideUp
    case SlideDown
    case Fade
}

enum WindowHideAnimation{
    case SlideUp
    case SlideDown
    case Fade
}


final class WindowShower: NSObject {
    static let sharedInstance = WindowShower()
    var windowStack = [UIWindow]()
    
    private var AnimationShowTime = 0.6
    private var AnimationHideTime = 0.5
    private var tapped = false
    private var showCompletion: (()->())?
    private var hideCompletion: (()->())?
    private var touchHideCompletion: (()->())?
    private var touchHideAnimation: WindowHideAnimation?
    var touchPreHideBlock: (()->())?
    var backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.7)
    
    func showViewController(viewController: UIViewController, windowFrame frame: CGRect, animation: WindowShowAnimation, shouldHideOnTouch shouldHide: Bool, hideAnimation: WindowHideAnimation? = nil) {
        
        let window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window.backgroundColor = UIColor.clearColor()
        window.windowLevel = UIWindowLevelNormal + 0.001
        window.makeKeyAndVisible()
        windowStack.append(window)
        window.rootViewController = viewController
        
        if shouldHide {
            window.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "tapped:"))
            if let animation = hideAnimation {
                touchHideAnimation = animation
            }
        }
        
        switch animation {
        case .SlideUp:
            viewController.view.frame = CGRectMake(frame.origin.x, UIScreen.mainScreen().bounds.height, frame.width, frame.height)
        case .SlideDown:
            viewController.view.frame = CGRectMake(frame.origin.x, -frame.origin.y, frame.width, frame.height)
        case .Fade:
            viewController.view.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.width, frame.height)
            viewController.view.alpha = 0
        }
        
        UIView.animateWithDuration(AnimationShowTime, delay: 0, usingSpringWithDamping: 10.0, initialSpringVelocity: 1.0, options: [], animations: {
            
            viewController.view.frame.origin = frame.origin
            viewController.view.alpha = 1
            window.backgroundColor = self.backgroundColor
            
            }, completion: {(completed) in self.showCompletion?(); self.showCompletion = nil})
    }
    
    func tapped(recogniser: UITapGestureRecognizer) {
        let touchLocation = recogniser.locationOfTouch(0, inView: windowStack.last)
        let currentViewController = windowStack.last?.rootViewController
        guard let current = currentViewController else { return }
        if !CGRectContainsPoint(current.view.frame, touchLocation) {
            tapped = true
            hideWindow(touchHideAnimation ?? .SlideDown)
        }
    }
    
    func setShowCompletion(completion: (()->())?) {
        self.showCompletion = completion
    }
    
    func setHideCompletion(completion: (()->())?) {
        self.hideCompletion = completion
    }
    
    func setTouchHideCompletion(completion: (()->())?) {
        self.touchHideCompletion = completion
    }
    
    
    func hide() {
        hideWindow(.SlideDown)
    }
    
    func hideWindow(animation: WindowHideAnimation) {
        
        let window: UIWindow
        if self.windowStack.count > 0 {
            window = windowStack.last!
            windowStack.removeLast()
        } else {
            return
        }
        
        let view = window.rootViewController?.view
        if view == nil {
            window.resignKeyWindow()
            window.resignFirstResponder()
            window.rootViewController = nil
            self.hideCompletion?()
            self.hideCompletion = nil
            if self.tapped {
                self.touchHideCompletion?()
                self.touchHideCompletion = nil
                self.tapped = false
            }
        }
        touchPreHideBlock?()
        UIView.animateWithDuration(AnimationHideTime, animations: {
            
            switch animation {
            case .SlideUp:
                window.rootViewController?.view.center = CGPoint(x: view!.center.x, y: -view!.frame.origin.y)
            case .SlideDown:
                window.rootViewController?.view.frame.origin = CGPoint(x: view!.frame.origin.x, y: UIScreen.mainScreen().bounds.height + 300)
            case .Fade:
                window.rootViewController?.view.alpha = 0
            }
            
            window.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.0)
            
            }) { (completed) in
                window.resignKeyWindow()
                window.resignFirstResponder()
                window.rootViewController = nil
                self.hideCompletion?()
                self.hideCompletion = nil
                if self.tapped {
                    self.touchHideCompletion?()
                    self.touchHideCompletion = nil
                    self.tapped = false
                }
        }
    }
}
