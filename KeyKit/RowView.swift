//
//  RowView.swift
//  KeyKit
//
//  Created by Dima Bart on 2016-01-27.
//  Copyright © 2016 Dima Bart. All rights reserved.
//

import UIKit

public class RowView: UIView {

    public let row:  Row
    public let keys: [KeyView]
    
    // ----------------------------------
    //  MARK: - Init -
    //
    public init(row: Row, targetable: KeyTargetable) {
        self.row  = row
        self.keys = row.keys.viewsWith(targetable)
        
        super.init(frame: CGRectZero)
        
        self.addSubviews(self.keys)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // ----------------------------------
    //  MARK: - Layout -
    //
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        var keyViews      = self.keys
        var keyWidths     = [CGFloat]()
        
        let rowHeight     = self.bounds.height
        let rowWidth      = self.bounds.width
        var totalKeyWidth = CGFloat(0.0)
        
        /* ---------------------------------
         ** Calculate all key widths before
         ** laying out the key views.
         */
        for keyView in keyViews {
            let keyWidth   = rowWidth * CGFloat(keyView.key.length) * 0.01
            totalKeyWidth += keyWidth
            keyWidths.append(keyWidth)
        }
        
        
        /* ---------------------------------
         ** If the first key is an alternate
         ** style key, we'll pin it to edge.
         */
        let leftKey  = keyViews.first!
        let pinLeft  = leftKey.key.style == .Alternate
        if pinLeft {
            let keyWidth = keyWidths.removeFirst()
            keyViews.removeFirst()
            
            totalKeyWidth -= keyWidth
            leftKey.frame  = CGRect(x: 0.0, y: 0.0, width: keyWidth, height: rowHeight)
        }
        
        /* ---------------------------------
         ** If the last key is an alternate
         ** style key, we'll pin it to edge.
         */
        let rightKey = keyViews.last!
        let pinRight = rightKey.key.style  == .Alternate
        if pinRight {
            let keyWidth = keyWidths.removeLast()
            keyViews.removeLast()
            
            totalKeyWidth -= keyWidth
            rightKey.frame = CGRect(x: rowWidth - keyWidth, y: 0.0, width: keyWidth, height: rowHeight)
        }
        
        /* ---------------------------------
         ** Calculate the offset for keys
         ** that are not edge-pinned.
         */
        var offset: CGFloat
        
        if pinLeft && pinRight {
            
            let keyWidth       = leftKey.frame.width + rightKey.frame.width
            let remainingWidth = rowWidth - keyWidth
            
            offset = (remainingWidth - totalKeyWidth) * 0.5 + leftKey.frame.width
            
        } else if pinLeft {
            
            let keyWidth       = leftKey.frame.width
            let remainingWidth = rowWidth - keyWidth
            
            offset = (remainingWidth - totalKeyWidth) * 0.5 + keyWidth
            
        } else if pinRight {
            
            let keyWidth       = rightKey.frame.width
            let remainingWidth = rowWidth - keyWidth
            
            offset = (remainingWidth - totalKeyWidth) * 0.5
            
        } else {
            offset = (rowWidth - totalKeyWidth) * 0.5
        }
        
        /* ---------------------------------
         ** Layout in sequence the remaining
         ** keys regardless of their style.
         */
        for (index, key) in keyViews.enumerate() {
            key.frame = CGRect(x: offset, y: 0.0, width: keyWidths[index], height: rowHeight)
            offset   += key.frame.width
        }
    }
}

// ----------------------------------
//  MARK: - CollectionType -
//
private extension CollectionType where Generator.Element == Key {
    private func viewsWith(targetable: KeyTargetable) -> [KeyView] {
        return self.map {
            KeyView(key: $0, targetable: targetable)
        }
    }
}