//
//  KeyView.swift
//  KeyKit
//
//  Created by Dima Bart on 2016-01-27.
//  Copyright © 2016 Dima Bart. All rights reserved.
//

import UIKit

public protocol KeyTargetable: class {
    func keyShouldRepeat(_ keyView: KeyView) -> Bool
    func keyDidRepeat(_ keyView: KeyView)
    func keyReceivedAction(_ keyView: KeyView)
    func key(_ keyView: KeyView, didChangeTrackingState tracking: Bool, draggedIn: Bool?)
}

open class KeyView: TintedButton {
    
    public enum TrackingState {
        case normal
        case highlighted
        case selected
    }
    
    private(set) var isDown      = false
    private(set) var isRepeating = false
    
    open let key: Key
    
    open var showsBackground: Bool   = true
    open var repeatDelay:     Double = 0.3
    open var repeatFrequency: Double = 0.085
    
    private weak var targetable: KeyTargetable?
    private var keyColors = [String : UIColor]()
    
    // ----------------------------------
    //  MARK: - Default Styles -
    //
    open static var setDefaultAppearance: () -> Void = {
        let proxy = KeyView.appearance()
        
        // Key fonts
        
        let font = UIFont.systemFont(ofSize: 18.0)
        
        proxy.setTextFont(font, forStyle: .main)
        proxy.setTextFont(font, forStyle: .alternate)
        proxy.setTextFont(font, forStyle: .done)
        
        // Key colors
        
        let textDark  = Color.rgb(r:  50, g: 77,  b:  99)
        let textLight = Color.rgb(r: 121, g: 140, b: 156)
        let textAlt   = Color.rgb(r: 255, g: 255, b: 255)
        
        proxy.setTextColor(textLight, forStyle: .main,      state: .normal)
        proxy.setTextColor(textDark,  forStyle: .alternate, state: .normal)
        proxy.setTextColor(textAlt,   forStyle: .done,      state: .normal)
        
        proxy.setTextColor(textLight, forStyle: .main,      state: .highlighted)
        proxy.setTextColor(textAlt,   forStyle: .alternate, state: .highlighted)
        proxy.setTextColor(textAlt,   forStyle: .done,      state: .highlighted)
        
        proxy.setTextColor(textLight, forStyle: .main,      state: .selected)
        proxy.setTextColor(textAlt,   forStyle: .alternate, state: .selected)
        proxy.setTextColor(textAlt,   forStyle: .done,      state: .selected)
        
        // Key Backgrounds
        
        proxy.setKeyColor(Color.rgb(r: 255, g: 255, b: 255), forStyle: .main,      state: .normal)
        proxy.setKeyColor(Color.rgb(r: 196, g: 204, b: 211), forStyle: .alternate, state: .normal)
        proxy.setKeyColor(Color.rgb(r:  70, g: 183, b: 204), forStyle: .done,      state: .normal)
        
        proxy.setKeyColor(Color.rgb(r: 235, g: 235, b: 235), forStyle: .main,      state: .highlighted)
        proxy.setKeyColor(Color.rgb(r:  70, g: 183, b: 204), forStyle: .alternate, state: .highlighted)
        proxy.setKeyColor(Color.rgb(r:  48, g: 147, b: 166), forStyle: .done,      state: .highlighted)
        
        proxy.setKeyColor(Color.rgb(r: 235, g: 235, b: 235), forStyle: .main,      state: .selected)
        proxy.setKeyColor(Color.rgb(r:  70, g: 183, b: 204), forStyle: .alternate, state: .selected)
        proxy.setKeyColor(Color.rgb(r:  48, g: 147, b: 166), forStyle: .done,      state: .selected)
        return {}
    }()
    
    // ----------------------------------
    //  MARK: - UIAppearance -
    //
    @objc open dynamic func setTextFont(_ font: UIFont, forStyle style: KeyStyle) {
        if self.key.style == style {
            self.titleLabel?.font = font
        }
    }
    
    @objc open dynamic func textFontForStyle(_ style: KeyStyle) -> UIFont? {
        if self.key.style == style {
            return self.titleLabel?.font
        }
        return nil
    }
    
    @objc open dynamic func setTextColor(_ color: UIColor, forStyle style: KeyStyle, state: UIControlState) {
        if self.key.style == style {
            self.setTitleColor(color, for: state)
        }
    }
    
    @objc open dynamic func textColorForStyle(_ style: KeyStyle, state: UIControlState) -> UIColor? {
        if self.key.style == style {
            return self.titleColor(for: state)
        }
        return nil
    }
    
    @objc open dynamic func setKeyColor(_ color: UIColor, forStyle style: KeyStyle, state: UIControlState) {
        guard self.showsBackground else {
            self.setBackgroundImage(nil, for: state)
            return
        }
        
        if self.key.style == style {
            self.keyColors[state.key] = color
            self.setBackgroundImage(KeyBackground.imageForColor(color), for: state)
        }
    }
    
    @objc open dynamic func keyColorForStyle(_ style: KeyStyle, state: UIControlState) -> UIColor? {
        if self.key.style == style {
            return self.keyColors[state.key]
        }
        return nil
    }
    
    // ----------------------------------
    //  MARK: - Init -
    //
    public init(key: Key, targetable: KeyTargetable) {
        _               = KeyView.setDefaultAppearance
        self.key        = key
        self.targetable = targetable
        
        super.init(frame: CGRect.zero)
        
        self.addTarget(self, action: #selector(touchUp),        for: .touchUpInside)
        self.addTarget(self, action: #selector(touchDown),      for: .touchDown)
        self.addTarget(self, action: #selector(dragIn),         for: .touchDragInside)
        self.addTarget(self, action: #selector(touchCancelled), for: .touchCancel)
        
        self.initState()
        self.initLabel()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    private func initState() {
        self.adjustsImageWhenHighlighted = false
        self.setTitleShadowColor(UIColor.clear, for: .normal)
        
        if let label = self.titleLabel {
            label.textAlignment = .center
            label.lineBreakMode = .byClipping
            label.numberOfLines = 1
        } else {
            fatalError("Failed to configure KeyView label style. No titleLabel found.")
        }
    }
    
    private func initLabel() {
        switch self.key.label {
        case .char(let string):
            
            self.setTitle(string, for: .normal)
            
        case .icon(let imageName):
            
            let image: UIImage
            if let bundleImage = UIImage(named: imageName) {
                image = bundleImage
            } else if let keyKitImage = UIImage(named: imageName, in: Bundle(for: self.classForCoder), compatibleWith: nil) {
                image = keyKitImage
            } else {
                fatalError("KeyView failed to find image named: \(imageName).")
            }
            self.setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
        }
    }
    
    // ----------------------------------
    //  MARK: - Tracking -
    //
    open func setTrackingState(_ state: TrackingState) {
        switch state {
        case .normal:
            self.isHighlighted = false
            self.isSelected    = false
            
        case .highlighted:
            self.isHighlighted = true
            self.isSelected    = false
            
        case .selected:
            self.isHighlighted = false
            self.isSelected    = true
        }
    }
    
    // ----------------------------------
    //  MARK: - Repetition -
    //
    private func enqueueRepeatDelay(_ sender: UIButton) {
        let shouldRepeat = self.targetable?.keyShouldRepeat(self) ?? false
        if shouldRepeat {
            NSObject.cancelPreviousPerformRequests(withTarget: self)
            self.perform(#selector(repeatTouchDown), with: sender, afterDelay: self.repeatDelay)
        }
    }
    
    @objc private func repeatTouchDown(_ sender: UIButton) {
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
    @objc private func touchUp(_ sender: UIButton) {
        self.isDown = false
        
        self.targetable?.keyReceivedAction(self)
        self.targetable?.key(self, didChangeTrackingState: false, draggedIn: nil)
    }
    
    @objc private func touchDown(_ sender: UIButton) {
        self.isDown = true
        
        self.targetable?.key(self, didChangeTrackingState: true, draggedIn: false)
        self.enqueueRepeatDelay(sender)
    }
    
    @objc private func dragIn(_ sender: UIButton) {
        self.isDown = true
        
        self.targetable?.key(self, didChangeTrackingState: true, draggedIn: true)
    }
    
    @objc private func touchDownRepeat(_ sender: UIButton) {
        self.targetable?.keyDidRepeat(self)
    }
    
    @objc private func touchCancelled(_ sender: UIButton) {
        self.isDown = false
        
        self.targetable?.key(self, didChangeTrackingState: false, draggedIn: false)
    }
    
    // ----------------------------------
    //  MARK: - Helpers -
    //
    private func after(_ delay: Double, block: @escaping ()->()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            block()
        }
    }
}

// ------------------------------------
//  MARK: - KeyBackground Rendering -
//
private struct KeyBackground {
    
    private static var images = [String : UIImage]()
    
    fileprivate static func imageForColor(_ color: UIColor) -> UIImage {
        let colorKey = color.key
        if let image = self.images[colorKey] {
            return image
            
        } else {
            let image             = self.drawBackgroudImageWith(color)
            self.images[colorKey] = image
            
            return image
        }
    }
    
    private static func drawBackgroudImageWith(_ color: UIColor) -> UIImage {
        
        let space  = CGFloat(3.0)
        let radius = CGFloat(6.0)
        let line   = 1.0 / UIScreen.main.scale * 3.0
        
        let length = (space * 2.0) + (radius * 2.0) + line + 10.0
        let rect   = CGRect(x: 0.0, y: 0.0, width: length, height: length)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        
        let path       = UIBezierPath(roundedRect: rect.insetBy(dx: space + line * 0.5, dy: space + line * 0.5), cornerRadius: radius)
        path.lineWidth = line
        
        color.setFill()
        path.fill()
        
        let inset = space + radius + line * 2.0
        let image = UIGraphicsGetImageFromCurrentImageContext()!.resizableImage(withCapInsets: UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset))
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
        let color      = self.cgColor
        let components = color.components!
        
        var values = [String]()
        for component in components {
            let rounded = Int(component * 100.0)
            values.append("\(rounded)")
        }
        
        return values.joined(separator: ",")
    }
}
