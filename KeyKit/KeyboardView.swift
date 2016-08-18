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
    
    private var trackingView: TrackingView!
    
    // ----------------------------------
    //  MARK: - Default Styles -
    //
    public override static func initialize() {
        let proxy = KeyboardView.appearance()
        
        proxy.setKeyboardColor(Color.rgb(r: 237, g: 240, b: 242))
    }
    
    // ----------------------------------
    //  MARK: - UIAppearance -
    //
    public dynamic func setKeyboardColor(color: UIColor) {
        self.backgroundColor = color
    }
    
    public dynamic func keyboardColor() -> UIColor? {
        return self.backgroundColor
    }
    
    // ----------------------------------
    //  MARK: - Init -
    //
    public init(faceView: FaceView) {
        super.init(frame: CGRectZero)
        
        self.initTrackingView()
        self.setFaceView(faceView)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // ----------------------------------
    //  MARK: - Tracking View -
    //
    private func initTrackingView() {
        self.trackingView                  = TrackingView(frame: self.bounds)
        self.trackingView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.trackingView.backgroundColor  = UIColor.clearColor()
        
        self.addSubview(self.trackingView)
    }
    
    private func surfaceTrackingView() {
        self.bringSubviewToFront(self.trackingView)
    }
    
    private func startTracking(faceView: FaceView) {
        self.trackingView.faceView = faceView
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
        
        self.surfaceTrackingView()
        self.startTracking(faceView)
    }
    
    // ----------------------------------
    //  MARK: - Layout -
    //
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        self.faceView.frame     = self.bounds
        self.trackingView.frame = self.bounds
    }
    
    // ----------------------------------
    //  MARK: - Key Queries -
    //
    public func keyViewsMatching(predicate: (Key) -> Bool) -> [KeyView] {
        var results = [KeyView]()
        for row in self.faceView.rows {
            for key in row.keys {
                if predicate(key.key) {
                    results.append(key)
                }
            }
        }
        return results
    }
    
    // ----------------------------------
    //  MARK: - Updates -
    //
    public func updateReturnKeysFor(type: UIReturnKeyType) {
        
        let returnKeys = keyViewsMatching {
            $0.value == Key.Value.Action(.Return)
        }
        
        for keyView in returnKeys {
            keyView.styleForReturnKeyType(type)
        }
        
    }
}
