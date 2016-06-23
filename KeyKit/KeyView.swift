//
//  KeyView.swift
//  KeyKit
//
//  Created by Dima Bart on 2016-01-27.
//  Copyright © 2016 Dima Bart. All rights reserved.
//

import UIKit

public protocol KeyTargetable: class {
    func keyDidRepeat(keyView: KeyView)
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
        
        self.addTarget(self, action: #selector(touchUp),         forControlEvents: .TouchUpInside)
        self.addTarget(self, action: #selector(touchDown),       forControlEvents: .TouchDown)
        self.addTarget(self, action: #selector(touchDownRepeat), forControlEvents: .TouchDownRepeat)
        self.addTarget(self, action: #selector(touchCancelled),  forControlEvents: .TouchCancel)
        
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
            label.font          = UIFont.boldSystemFontOfSize(18.0)
            label.textAlignment = .Center
            label.lineBreakMode = .ByClipping
            label.numberOfLines = 1
        }
        
        self.updateIconTintForState()
        
        /* ---------------------------------
         ** Set text color for style
         */
        self.setTitleColor(self.titleColorForStyle(self.key.style, state: .Normal),      forState: .Normal)
        self.setTitleColor(self.titleColorForStyle(self.key.style, state: .Highlighted), forState: .Highlighted)
        self.setTitleColor(self.titleColorForStyle(self.key.style, state: .Selected),    forState: .Selected)
        
        /* ---------------------------------
         ** Set background image for style
         */
        switch self.key.style {
        case .Main:
            self.setBackgroundImage(KeyView.mainNormalImage,      forState: .Normal)
            self.setBackgroundImage(KeyView.mainHighlightedImage, forState: .Highlighted)
            self.setBackgroundImage(KeyView.mainSelectedImage,    forState: .Selected)
            
        case .Alternate:
            self.setBackgroundImage(KeyView.alternateNormalImage,      forState: .Normal)
            self.setBackgroundImage(KeyView.alternateHighlightedImage, forState: .Highlighted)
            self.setBackgroundImage(KeyView.alternateSelectedImage,    forState: .Selected)
            
        case .Done:
            self.setBackgroundImage(KeyView.doneNormalImage,      forState: .Normal)
            self.setBackgroundImage(KeyView.doneHighlightedImage, forState: .Highlighted)
            self.setBackgroundImage(KeyView.doneSelectedImage,    forState: .Selected)
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
    //  MARK: - State Update -
    //
    public override var highlighted: Bool {
        didSet {
            self.updateIconTintForState()
        }
    }
    
    public override var selected: Bool {
        didSet {
            self.updateIconTintForState()
        }
    }
    
    private func updateIconTintForState() {
        let trackingState: TrackingState
        
        if self.state.contains(.Selected) {
            trackingState = .Selected
        } else if self.state.contains(.Highlighted) {
            trackingState = .Highlighted
        } else {
            trackingState = .Normal
        }
        
        self.tintColor = self.titleColorForStyle(self.key.style, state: trackingState)
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
    //  MARK: - Touch Tracking -
    //
    @objc private func touchUp(sender: UIButton) {
        self.targetable?.keyReceivedAction(self)
        self.targetable?.key(self, didChangeTrackingState: false)
    }
    
    @objc private func touchDown(sender: UIButton) {
        self.targetable?.key(self, didChangeTrackingState: true)
    }
    
    @objc private func touchDownRepeat(sender: UIButton) {
        self.targetable?.keyDidRepeat(self)
    }
    
    @objc private func touchCancelled(sender: UIButton) {
        self.targetable?.key(self, didChangeTrackingState: false)
    }
    
    // ----------------------------------
    //  MARK: - Title Colors -
    //
    private func titleColorForStyle(style: Key.Style, state: TrackingState) -> UIColor {
        switch state {
        case .Normal:
            
            switch style {
            case .Main:
                return Color.rgb(r: 121, g: 140, b: 156)
            case .Alternate:
                return Color.rgb(r:  50, g: 77,  b:  99)
            case .Done:
                return Color.rgb(r: 255, g: 255, b: 255)
            }
            
        case .Selected: fallthrough
        case .Highlighted:
            
            switch style {
            case .Main:
                return Color.rgb(r: 121, g: 140, b: 156)
            case .Alternate:
                return Color.rgb(r: 255, g: 255, b: 255)
            case .Done:
                return Color.rgb(r: 255, g: 255, b: 255)
            }
        }
    }
    
    // ----------------------------------
    //  MARK: - Normal Drawing -
    //
    private static var mainNormalImage      = KeyView.drawBackgroudImage(.Main,      state: .Normal)
    private static var alternateNormalImage = KeyView.drawBackgroudImage(.Alternate, state: .Normal)
    private static var doneNormalImage      = KeyView.drawBackgroudImage(.Done,      state: .Normal)
    
    // ----------------------------------
    //  MARK: - Highlighted Drawing -
    //
    private static var mainHighlightedImage      = KeyView.drawBackgroudImage(.Main,      state: .Highlighted)
    private static var alternateHighlightedImage = KeyView.drawBackgroudImage(.Alternate, state: .Highlighted)
    private static var doneHighlightedImage      = KeyView.drawBackgroudImage(.Done,      state: .Highlighted)
    
    // ----------------------------------
    //  MARK: - Selected Drawing -
    //
    private static var mainSelectedImage      = KeyView.drawBackgroudImage(.Main,      state: .Selected)
    private static var alternateSelectedImage = KeyView.drawBackgroudImage(.Alternate, state: .Selected)
    private static var doneSelectedImage      = KeyView.drawBackgroudImage(.Done,      state: .Selected)
    
    // ----------------------------------
    //  MARK: - Drawing Helper -
    //
    private static func drawBackgroudImage(style: Key.Style, state: TrackingState) -> UIImage {
        
        let space  = CGFloat(3.0)
        let radius = CGFloat(6.0)
        let line   = 1.0 / UIScreen.mainScreen().scale * 3.0
        
        let length = (space * 2.0) + (radius * 2.0) + line + 10.0
        let rect   = CGRect(x: 0.0, y: 0.0, width: length, height: length)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        
        let path       = UIBezierPath(roundedRect: rect.insetBy(dx: space + line * 0.5, dy: space + line * 0.5), cornerRadius: radius)
        path.lineWidth = line
        
        /* ---------------------------------
         ** Determine the color for this key
         ** style and state.
         */
        let color: UIColor
        switch state {
        case .Normal:
            
            switch style {
            case .Main:
                color = Color.rgb(r: 255, g: 255, b: 255)
            case .Alternate:
                color = Color.rgb(r: 196, g: 204, b: 211)
            case .Done:
                color = Color.rgb(r:  70, g: 183, b: 204)
            }
            
        case .Selected: fallthrough
        case .Highlighted:
            
            switch style {
            case .Main:
                color = Color.rgb(r: 235, g: 235, b: 235)
            case .Alternate:
                color = Color.rgb(r:  70, g: 183, b: 204)//Color.rgb(r: 171, g: 180, b: 187)
            case .Done:
                color = Color.rgb(r:  48, g: 147, b: 166)
            }
        }
        
        /* ---------------------------------
         ** Set and fill the key with color
         */
        color.setFill()
        path.fill()
        
        let inset = space + radius + line * 2.0
        let image = UIGraphicsGetImageFromCurrentImageContext().resizableImageWithCapInsets(UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset))
        UIGraphicsEndImageContext()
        
        return image
    }
}
