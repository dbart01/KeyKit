//
//  KeyView.swift
//  KeyKit
//
//  Created by Dima Bart on 2016-01-27.
//  Copyright © 2016 Dima Bart. All rights reserved.
//

import UIKit

public protocol KeyTargetable: class {
    func keyShouldRepeat(keyView: KeyView) -> Bool
    func keyDidRepeat(keyView: KeyView)
    func keyReceivedAction(keyView: KeyView)
    func key(keyView: KeyView, didChangeTrackingState tracking: Bool, draggedIn: Bool?)
}

public class KeyView: TintedButton {

    public enum TrackingState {
        case Normal
        case Highlighted
        case Selected
    }
    
    private(set) var isDown      = false
    private(set) var isRepeating = false
    
    private(set) public var key: Key
    
    public var repeatDelay:     Double = 0.3
    public var repeatFrequency: Double = 0.085
    
    private weak var targetable: KeyTargetable?
    private var keyColors = [String : UIColor]()
    
    // ----------------------------------
    //  MARK: - Default Styles -
    //
    public override static func initialize() {
        let proxy = KeyView.appearance()
        
        // Key fonts
        
        let font = UIFont.systemFontOfSize(18.0)
        
        proxy.setTextFont(font, forStyle: .Main)
        proxy.setTextFont(font, forStyle: .Alternate)
        proxy.setTextFont(font, forStyle: .Done)
        
        // Key colors
        
        let textDark  = Color.rgb(r:  50, g: 77,  b:  99)
        let textLight = Color.rgb(r: 121, g: 140, b: 156)
        let textAlt   = Color.rgb(r: 255, g: 255, b: 255)
        
        proxy.setTextColor(textLight, forStyle: .Main,      state: .Normal)
        proxy.setTextColor(textDark,  forStyle: .Alternate, state: .Normal)
        proxy.setTextColor(textAlt,   forStyle: .Done,      state: .Normal)
        
        proxy.setTextColor(textLight, forStyle: .Main,      state: .Highlighted)
        proxy.setTextColor(textAlt,   forStyle: .Alternate, state: .Highlighted)
        proxy.setTextColor(textAlt,   forStyle: .Done,      state: .Highlighted)
        
        proxy.setTextColor(textLight, forStyle: .Main,      state: .Selected)
        proxy.setTextColor(textAlt,   forStyle: .Alternate, state: .Selected)
        proxy.setTextColor(textAlt,   forStyle: .Done,      state: .Selected)
        
        // Key Backgrounds
        
        proxy.setKeyColor(Color.rgb(r: 255, g: 255, b: 255), forStyle: .Main,      state: .Normal)
        proxy.setKeyColor(Color.rgb(r: 196, g: 204, b: 211), forStyle: .Alternate, state: .Normal)
        proxy.setKeyColor(Color.rgb(r:  70, g: 183, b: 204), forStyle: .Done,      state: .Normal)
        
        proxy.setKeyColor(Color.rgb(r: 235, g: 235, b: 235), forStyle: .Main,      state: .Highlighted)
        proxy.setKeyColor(Color.rgb(r:  70, g: 183, b: 204), forStyle: .Alternate, state: .Highlighted)
        proxy.setKeyColor(Color.rgb(r:  48, g: 147, b: 166), forStyle: .Done,      state: .Highlighted)
        
        proxy.setKeyColor(Color.rgb(r: 235, g: 235, b: 235), forStyle: .Main,      state: .Selected)
        proxy.setKeyColor(Color.rgb(r:  70, g: 183, b: 204), forStyle: .Alternate, state: .Selected)
        proxy.setKeyColor(Color.rgb(r:  48, g: 147, b: 166), forStyle: .Done,      state: .Selected)
    }
    
    // ----------------------------------
    //  MARK: - UIAppearance -
    //
    public dynamic func setTextFont(font: UIFont, forStyle style: KeyStyle) {
        if self.key.style == style {
            self.titleLabel?.font = font
        }
    }
    
    public dynamic func textFontForStyle(style: KeyStyle) -> UIFont? {
        if self.key.style == style {
            return self.titleLabel?.font
        }
        return nil
    }
    
    public dynamic func setTextColor(color: UIColor, forStyle style: KeyStyle, state: UIControlState) {
        if self.key.style == style {
            self.setTitleColor(color, forState: state)
        }
    }
    
    public dynamic func textColorForStyle(style: KeyStyle, state: UIControlState) -> UIColor? {
        if self.key.style == style {
            return self.titleColorForState(state)
        }
        return nil
    }
    
    public dynamic func setKeyColor(color: UIColor, forStyle style: KeyStyle, state: UIControlState) {
        if self.key.style == style {
            self.keyColors[state.key] = color
            self.setBackgroundImage(KeyBackground.imageForColor(color), forState: state)
        }
    }
    
    public dynamic func keyColorForStyle(style: KeyStyle, state: UIControlState) -> UIColor? {
        if self.key.style == style {
            return self.keyColors[state.key]
        }
        return nil
    }
    
    // ----------------------------------
    //  MARK: - Init -
    //
    public init(key: Key, targetable: KeyTargetable) {
        self.key        = key
        self.targetable = targetable
        
        super.init(frame: CGRectZero)
        
        self.addTarget(self, action: #selector(touchUp),        forControlEvents: .TouchUpInside)
        self.addTarget(self, action: #selector(touchDown),      forControlEvents: .TouchDown)
        self.addTarget(self, action: #selector(dragIn),         forControlEvents: .TouchDragInside)
        self.addTarget(self, action: #selector(touchCancelled), forControlEvents: .TouchCancel)
        
        self.initState()
        self.initLabel()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    private func initState() {
        
        self.adjustsImageWhenHighlighted = false
        self.setTitleShadowColor(UIColor.clearColor(), forState: .Normal)
        
        if let label = self.titleLabel {
            label.textAlignment = .Center
            label.lineBreakMode = .ByClipping
            label.numberOfLines = 1
        } else {
            fatalError("Failed to configure KeyView label style. No titleLabel found.")
        }
    }
    
    private func initLabel() {
        switch self.key.label {
        case .Char(let string):
            
            self.setTitle(string, forState: .Normal)
            
        case .Icon(let imageName):
            
            if let image = UIImage(named: imageName, inBundle: NSBundle(forClass: self.classForCoder), compatibleWithTraitCollection: nil) {
                self.setImage(image.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
            } else {
                fatalError("KeyView failed to find image named: \(imageName).")
            }
        }
    }
    
    // ----------------------------------
    //  MARK: - Tracking -
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
    //  MARK: - Repetition -
    //
    private func enqueueRepeatDelay(sender: UIButton) {
        let shouldRepeat = self.targetable?.keyShouldRepeat(self) ?? false
        if shouldRepeat {
            NSObject.cancelPreviousPerformRequestsWithTarget(self)
            self.performSelector(#selector(repeatTouchDown), withObject: sender, afterDelay: self.repeatDelay)
        }
    }
    
    @objc private func repeatTouchDown(sender: UIButton) {
        self.isRepeating = self.isDown
        if self.isDown {
            self.touchDownRepeat(sender)
            self.after(self.repeatFrequency) {
                self.repeatTouchDown(sender)
            }
        }
    }
    
    // ----------------------------------
    //  MARK: - Touch Tracking -
    //
    @objc private func touchUp(sender: UIButton) {
        self.isDown = false
        
        self.targetable?.keyReceivedAction(self)
        self.targetable?.key(self, didChangeTrackingState: false, draggedIn: nil)
    }
    
    @objc private func touchDown(sender: UIButton) {
        self.isDown = true
        
        self.targetable?.key(self, didChangeTrackingState: true, draggedIn: false)
        self.enqueueRepeatDelay(sender)
    }
    
    @objc private func dragIn(sender: UIButton) {
        self.isDown = true
        
        self.targetable?.key(self, didChangeTrackingState: true, draggedIn: true)
    }
    
    @objc private func touchDownRepeat(sender: UIButton) {
        self.targetable?.keyDidRepeat(self)
    }
    
    @objc private func touchCancelled(sender: UIButton) {
        self.isDown = false
        
        self.targetable?.key(self, didChangeTrackingState: false, draggedIn: false)
    }
    
    // ----------------------------------
    //  MARK: - Helpers -
    //
    private func after(delay: Double, block: dispatch_block_t) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            block()
        }
    }
    
    // ----------------------------------
    //  MARK: - Mutations -
    //
    public func setKey(newKey: Key) {
        key = newKey
        initLabel()
    }
}

// ------------------------------------
//  MARK: - KeyBackground Rendering -
//
private struct KeyBackground {
    
    private static var images = [String : UIImage]()
    
    private static func imageForColor(color: UIColor) -> UIImage {
        let colorKey = color.key
        if let image = self.images[colorKey] {
            return image
            
        } else {
            let image             = self.drawBackgroudImageWith(color)
            self.images[colorKey] = image
            
            return image
        }
    }
    
    private static func drawBackgroudImageWith(color: UIColor) -> UIImage {
        
        let space  = CGFloat(3.0)
        let radius = CGFloat(6.0)
        let line   = 1.0 / UIScreen.mainScreen().scale * 3.0
        
        let length = (space * 2.0) + (radius * 2.0) + line + 10.0
        let rect   = CGRect(x: 0.0, y: 0.0, width: length, height: length)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        
        let path       = UIBezierPath(roundedRect: rect.insetBy(dx: space + line * 0.5, dy: space + line * 0.5), cornerRadius: radius)
        path.lineWidth = line
        
        color.setFill()
        path.fill()
        
        let inset = space + radius + line * 2.0
        let image = UIGraphicsGetImageFromCurrentImageContext().resizableImageWithCapInsets(UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset))
        UIGraphicsEndImageContext()
        
        return image
    }
}

// ----------------------------------
//  MARK: - UIControlState -
//
extension UIControlState {
    var key: String {
        return String(self.rawValue)
    }
}

// ----------------------------------
//  MARK: - UIColor -
//
extension UIColor {
    var key: String {
        let color      = self.CGColor
        let count      = CGColorGetNumberOfComponents(color)
        let components = CGColorGetComponents(color)
        
        var values = [String]()
        for i in 0..<count {
            let component = (components + i).memory
            let rounded   = Int(component * 100.0)
            values.append("\(rounded)")
        }
        
        return values.joinWithSeparator(",")
    }
}
