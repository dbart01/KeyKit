//
//  KeyView.swift
//  KeyKit
//
//  Created by Dima Bart on 2016-01-27.
//  Copyright © 2016 Dima Bart. All rights reserved.
//

import UIKit

public protocol KeyTargetable: class {
    func keyTouchedDown(keyView: KeyView)
    func keyTouchedUp(keyView: KeyView)
}

public class KeyView: UIButton {

    public let key: Key
    
    private let targetable: KeyTargetable
    
    // ----------------------------------
    //  MARK: - Init -
    //
    public init(key: Key, targetable: KeyTargetable) {
        self.key        = key
        self.targetable = targetable
        
        super.init(frame: CGRectZero)
        
        self.addTarget(self, action: #selector(touchedUpAction),   forControlEvents: .TouchUpInside)
        self.addTarget(self, action: #selector(touchedDownAction), forControlEvents: .TouchDown)
        
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
        
        self.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        self.setTitleShadowColor(UIColor.clearColor(), forState: .Normal)
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
    //  MARK: - Touch Tracking -
    //
    @objc private func touchedUpAction(sender: UIButton) {
        self.targetable.keyTouchedUp(self)
    }
    
    @objc private func touchedDownAction(sender: UIButton) {
        self.targetable.keyTouchedDown(self)
    }
}
