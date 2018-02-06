//
//  KeyboardView.swift
//  KeyKit
//
//  Created by Dima Bart on 2016-01-27.
//  Copyright © 2016 Dima Bart. All rights reserved.
//

import UIKit

open class KeyboardView: UIView {
    
    private(set) var faceView: FaceView! {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    private var trackingView: TrackingView!
    
    // ----------------------------------
    //  MARK: - Default Styles -
    //
    open static var setDefaultAppearance: () -> Void = {
        let proxy = KeyboardView.appearance()
        
        proxy.setKeyboardColor(Color.rgb(r: 237, g: 240, b: 242))
        return {}
    }()
 
    
    // ----------------------------------
    //  MARK: - UIAppearance -
    //
    @objc open dynamic func setKeyboardColor(_ color: UIColor) {
        self.backgroundColor = color
    }
    
    @objc open dynamic func keyboardColor() -> UIColor? {
        return self.backgroundColor
    }
    
    // ----------------------------------
    //  MARK: - Init -
    //
    public init(faceView: FaceView?) {
        _ = KeyboardView.setDefaultAppearance
        super.init(frame: CGRect.zero)
        
        self.initTrackingView()
        
        if let faceView = faceView {
            self.setFaceView(faceView)
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // ----------------------------------
    //  MARK: - Tracking View -
    //
    private func initTrackingView() {
        self.trackingView                  = TrackingView(frame: self.bounds)
        self.trackingView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.trackingView.backgroundColor  = UIColor.clear
        
        self.addSubview(self.trackingView)
    }
    
    private func surfaceTrackingView() {
        self.bringSubview(toFront: self.trackingView)
    }
    
    private func startTracking(_ faceView: FaceView) {
        self.trackingView.faceView = faceView
    }
    
    // ----------------------------------
    //  MARK: - Setters -
    //
    @nonobjc
    open func setFaceView(_ faceView: FaceView) {
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
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        self.faceView.frame     = self.bounds
        self.trackingView.frame = self.bounds
    }
    
    // ----------------------------------
    //  MARK: - Key Queries -
    //
    open func keyViewsMatching(_ predicate: (Key) -> Bool) -> [KeyView] {
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
}
