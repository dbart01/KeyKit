//
//  TrackingView.swift
//  KeyKit
//
//  Created by Dima Bart on 2016-06-17.
//  Copyright © 2016 Dima Bart. All rights reserved.
//

import UIKit

internal class TrackingView: UIView {
    
    weak var faceView: FaceView?
    
    var repeatDelay:     Double = 0.3
    var repeatFrequency: Double = 0.05
    
    private var touchingKeys = [UITouch: KeyView]()
    private var trackingKeys = Set<KeyView>()
    
    // ----------------------------------
    //  MARK: - Init -
    //
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.multipleTouchEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
 
    // ----------------------------------
    //  MARK: - Touch Events -
    //
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let faceView = faceView else { return }
        
        for touch in touches {
            let location = touch.locationInView(faceView)
            
            if let keyView = self.keyAt(location) where !self.isTracking(keyView) {
                self.beginTracking(keyView, forTouch: touch, draggedIn: false)
                
                self.after(self.repeatDelay) { [weak self, touch] in
                    if let strongSelf = self where strongSelf.isTracking(keyView) && touch.window != nil {
                        strongSelf.repeatTracking(keyView)
                    }
                }
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let faceView = faceView else { return }
        
        for touch in touches {
            let location = touch.locationInView(faceView)
            
            /* -----------------------------------
             ** Check to see if the touch is still
             ** on a key.
             */
            if let keyView = self.keyAt(location) {
                
                /* ----------------------------------
                 ** Check to see if the key under the
                 ** touch is the same key. If not,
                 ** switch tracking to this new key.
                 */
                let currentTrackingKey = self.trackingKeyFor(touch)
                if currentTrackingKey != keyView {
                    self.endTrackingFor(touch, cancelled: true)
                    self.beginTracking(keyView, forTouch: touch, draggedIn: true)
                }
                
            } else {
                self.endTrackingFor(touch, cancelled: true)
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let _ = faceView else { return }
        
        for touch in touches {
            self.endTrackingFor(touch)
        }
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        guard let _ = faceView else { return }
        
        if let touches = touches {
            for touch in touches {
                self.endTrackingFor(touch, cancelled: true)
            }
        }
    }
    
    // ----------------------------------
    //  MARK: - Tracking Keys -
    //
    private func isTracking(keyView: KeyView) -> Bool {
        return self.trackingKeys.contains(keyView)
    }
    
    private func trackingKeyFor(touch: UITouch) -> KeyView? {
        return self.touchingKeys[touch]
    }
    
    private func beginTracking(keyView: KeyView, forTouch touch: UITouch, draggedIn: Bool) {
        self.touchingKeys[touch] = keyView
        self.trackingKeys.insert(keyView)
        
        keyView.setTrackingState(.Highlighted)
        
        if draggedIn {
            keyView.sendActionsForControlEvents(.TouchDragEnter)
        } else {
            keyView.sendActionsForControlEvents(.TouchDown)
        }
    }
    
    private func repeatTracking(keyView: KeyView) {
        keyView.sendActionsForControlEvents(.TouchDownRepeat)
        
        self.after(self.repeatFrequency) { [weak self] in
            if let strongSelf = self where strongSelf.isTracking(keyView) {
                strongSelf.repeatTracking(keyView)
            }
        }
    }
    
    private func endTrackingFor(touch: UITouch, cancelled: Bool = false) {
        if let keyView = self.touchingKeys[touch] {
            self.trackingKeys.remove(keyView)
            self.touchingKeys[touch] = nil
            
            keyView.setTrackingState(.Normal)
            
            if cancelled {
                keyView.sendActionsForControlEvents(.TouchCancel)
            } else {
                keyView.sendActionsForControlEvents(.TouchUpInside)
            }
        }
    }
    
    // ----------------------------------
    //  MARK: - Locating Keys -
    //
    private func keyAt(location: CGPoint) -> KeyView? {
        guard let faceView = self.faceView else { return nil }
        
        for row in faceView.rows where row.frame.contains(location) {
            
            let adjustedLocation = row.convertPoint(location, fromView: faceView)
            for key in row.keys where key.frame.contains(adjustedLocation) {
                return key
            }
        }
        return nil
    }
    
    // ----------------------------------
    //  MARK: - Helpers -
    //
    private func after(delay: Double, block: dispatch_block_t) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            block()
        }
    }
}
