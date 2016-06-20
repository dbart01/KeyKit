//
//  KeyView.swift
//  KeyKit
//
//  Created by Dima Bart on 2016-01-27.
//  Copyright © 2016 Dima Bart. All rights reserved.
//

import UIKit

public protocol KeyTargetable: class {
    func keyReceivedAction(keyView: KeyView)
    func key(keyView: KeyView, didChangeTrackingState tracking: Bool)
}

public class KeyView: UIButton {

    public enum TrackingState {
        case Normal
        case Highlighted
        case Selected
    }
    
    public let key: Key
    
    private weak var targetable: KeyTargetable?
    
    // ----------------------------------
    //  MARK: - Init -
    //
    public init(key: Key, targetable: KeyTargetable) {
        self.key        = key
        self.targetable = targetable
        
        super.init(frame: CGRectZero)
        
        self.addTarget(self, action: #selector(touchUp),        forControlEvents: .TouchUpInside)
        self.addTarget(self, action: #selector(touchDown),      forControlEvents: .TouchDown)
        self.addTarget(self, action: #selector(touchCancelled), forControlEvents: .TouchCancel)
        
        self.initState()
        self.initLabel()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    private func initState() {
        if let label = self.titleLabel {
            label.font          = UIFont.systemFontOfSize(18.0)
            label.textAlignment = .Center
            label.lineBreakMode = .ByClipping
            label.numberOfLines = 1
        }
        
        self.setTitleColor(UIColor.darkGrayColor(),    forState: .Normal)
        self.setTitleShadowColor(UIColor.clearColor(), forState: .Normal)
        
        self.setBackgroundImage(KeyView.backgroundImage,            forState: .Normal)
        self.setBackgroundImage(KeyView.highlightedBackgroundImage, forState: .Highlighted)
        self.setBackgroundImage(KeyView.selectedBackgroundImage,    forState: .Selected)
    }
    
    private func initLabel() {
        switch self.key.label {
        case .Char(let string):
            
            self.setTitle(string, forState: .Normal)
            
        case .Icon(let imageName):
            
            if let image = UIImage(named: imageName) {
                self.setImage(image, forState: .Normal)
            } else {
                fatalError("KeyView failed to find image named: \(imageName)")
            }
        }
    }
    
    // ----------------------------------
    //  MARK: - State Handling -
    //
    public func setTrackingState(state: TrackingState) {
        switch state {
        case .Normal:
            self.highlighted = false
            self.selected    = false
            
        case .Highlighted:
            self.highlighted = true
            self.selected    = false
            
        case .Selected:
            self.highlighted = false
            self.selected    = true
        }
    }
    
    // ----------------------------------
    //  MARK: - Touch Tracking -
    //
    @objc private func touchUp(sender: UIButton) {
        self.targetable?.keyReceivedAction(self)
        self.targetable?.key(self, didChangeTrackingState: false)
    }
    
    @objc private func touchDown(sender: UIButton) {
        self.targetable?.key(self, didChangeTrackingState: true)
    }
    
    @objc private func touchCancelled(sender: UIButton) {
        self.targetable?.key(self, didChangeTrackingState: false)
    }
    
    // ----------------------------------
    //  MARK: - Drawing -
    //
    private static var backgroundImage: UIImage = {
        return KeyView.drawBackgroudImage(.Normal)
    }()
    
    private static var highlightedBackgroundImage: UIImage = {
        return KeyView.drawBackgroudImage(.Highlighted)
    }()
    
    private static var selectedBackgroundImage: UIImage = {
        return KeyView.drawBackgroudImage(.Selected)
    }()
    
    private static func drawBackgroudImage(state: TrackingState) -> UIImage {
        
        let offset = CGFloat(1.5)
        let space  = CGFloat(3.0)
        let radius = CGFloat(6.0)
        let line   = 1.0 / UIScreen.mainScreen().scale * 3.0
        
        let length = (space * 2.0) + (radius * 2.0) + line + 10.0
        let rect   = CGRect(x: 0.0, y: 0.0, width: length, height: length)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        
        let path       = UIBezierPath(roundedRect: rect.insetBy(dx: space + line * 0.5, dy: space + line * 0.5), cornerRadius: radius)
        path.lineWidth = line
        
        switch state {
        case .Normal:
            path.applyTransform(CGAffineTransformMakeTranslation(0.0, offset))
            UIColor.darkGrayColor().setFill()
            path.fill()
            
            path.applyTransform(CGAffineTransformMakeTranslation(0.0, -offset))
            UIColor.whiteColor().setFill()
            path.fill()
            
        case .Highlighted:
            path.applyTransform(CGAffineTransformMakeTranslation(0.0, offset))
            UIColor.whiteColor().setFill()
            path.fill()
            
        case .Selected:
            path.applyTransform(CGAffineTransformMakeTranslation(0.0, offset))
            UIColor(white: 0.8, alpha: 1.0).setFill()
            path.fill()
        }
        
        let inset = space + radius + line * 2.0
        let image = UIGraphicsGetImageFromCurrentImageContext().resizableImageWithCapInsets(UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset))
        UIGraphicsEndImageContext()
        return image
    }
}
