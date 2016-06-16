//
//  KeyboardView.swift
//  KeyKit
//
//  Created by Dima Bart on 2016-01-27.
//  Copyright © 2016 Dima Bart. All rights reserved.
//

import UIKit

public class KeyboardView: UIView {
    
    private(set) var faceView: FaceView! {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    // ----------------------------------
    //  MARK: - Init -
    //
    public init(faceView: FaceView) {
        super.init(frame: CGRectZero)
        
        self.setFaceView(faceView)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // ----------------------------------
    //  MARK: - Setters -
    //
    @nonobjc
    public func setFaceView(faceView: FaceView) {
        if self.faceView != nil {
            self.faceView.removeFromSuperview()
        }
        
        self.faceView = faceView
        self.addSubview(faceView)
    }
    
    // ----------------------------------
    //  MARK: - Layout -
    //
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        self.faceView.frame = self.bounds
    }
}