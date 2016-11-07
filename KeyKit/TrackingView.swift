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
    
    private var touchingKeys = [UITouch: KeyView]()
    private var trackingKeys = Set<KeyView>()
    
    // ----------------------------------
    //  MARK: - Init -
    //
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isMultipleTouchEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
 
    // ----------------------------------
    //  MARK: - Touch Events -
    //
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let faceView = faceView else { return }
        
        for touch in touches {
            let location = touch.location(in: faceView)
            
            if let keyView = self.keyAt(location), !self.isTracking(keyView) {
                self.beginTracking(keyView, forTouch: touch, draggedIn: false)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let faceView = faceView else { return }
        
        for touch in touches {
            let location           = touch.location(in: faceView)
            let currentTrackingKey = self.trackingKeyFor(touch)
            
            /* ---------------------------------
             ** If a key started repeating don't
             ** change any tracking state until
             ** the touch has ended.
             */
            if currentTrackingKey != nil && currentTrackingKey!.isRepeating {
                continue
            }
            
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
                if currentTrackingKey != keyView {
                    self.endTrackingFor(touch, cancelled: true)
                    self.beginTracking(keyView, forTouch: touch, draggedIn: true)
                }
                
            } else {
                self.endTrackingFor(touch, cancelled: true)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let _ = faceView else { return }
        
        for touch in touches {
            self.endTrackingFor(touch)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>?, with event: UIEvent?) {
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
    private func isTracking(_ keyView: KeyView) -> Bool {
        return self.trackingKeys.contains(keyView)
    }
    
    private func trackingKeyFor(_ touch: UITouch) -> KeyView? {
        return self.touchingKeys[touch]
    }
    
    private func beginTracking(_ keyView: KeyView, forTouch touch: UITouch, draggedIn: Bool) {
        self.touchingKeys[touch] = keyView
        self.trackingKeys.insert(keyView)
        
        keyView.setTrackingState(.highlighted)
        
        if draggedIn {
            keyView.sendActions(for: .touchDragEnter)
        } else {
            keyView.sendActions(for: .touchDown)
        }
    }
    
    private func endTrackingFor(_ touch: UITouch, cancelled: Bool = false) {
        if let keyView = self.trackingKeyFor(touch) {
            self.trackingKeys.remove(keyView)
            self.touchingKeys[touch] = nil
            
            keyView.setTrackingState(.normal)
            
            if cancelled || keyView.isRepeating {
                keyView.sendActions(for: .touchCancel)
            } else {
                keyView.sendActions(for: .touchUpInside)
            }
        }
    }
    
    // ----------------------------------
    //  MARK: - Locating Keys -
    //
    private func keyAt(_ location: CGPoint) -> KeyView? {
        guard let faceView = self.faceView else { return nil }
        
        for row in faceView.rows where row.frame.contains(location) {
            
            let adjustedLocation = row.convert(location, from: faceView)
            for key in row.keys where key.frame.contains(adjustedLocation) {
                return key
            }
        }
        return nil
    }
}
