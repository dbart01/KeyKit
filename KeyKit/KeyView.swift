//
//  KeyView.swift
//  KeyKit
//
//  Created by Dima Bart on 2016-01-27.
//  Copyright © 2016 Dima Bart. All rights reserved.
//

import UIKit

public class KeyView: UIButton {

    public let key: Key
    
    // ----------------------------------
    //  MARK: - Init -
    //
    public init(key: Key, target: AnyObject, selector: Selector) {
        self.key = key
        
        super.init(frame: CGRectZero)
        
        self.addTarget(target, action: selector, forControlEvents: .TouchUpInside)
        
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
    
//    private func initMarking() {
//
//        switch self.key.label {
//        case .Char(let string):
//
//            let label              = UILabel(frame: self.bounds)
//            label.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
//            label.font             = UIFont.systemFontOfSize(18.0)
//            label.textAlignment    = .Center
//            label.lineBreakMode    = .ByClipping
//            label.numberOfLines    = 1
//            label.textColor        = UIColor.darkGrayColor()
//            label.backgroundColor  = UIColor.clearColor()
//            label.text             = string
//            
//            self.label = label
//            self.addSubview(label)
//            
//        case .Icon(let imageName):
//            
//            let image                  = UIImage(named: imageName)!
//            let imageView              = UIImageView(image: image)
//            imageView.contentMode      = .Center
//            imageView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
//            
//            self.imageView = imageView
//            self.addSubview(imageView)
//        }
//    }
}
