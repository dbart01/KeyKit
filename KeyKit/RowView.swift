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
        
        let width  = self.bounds.width / CGFloat(self.keys.count)
        let height = self.bounds.height
        var offset = CGFloat(0.0)
        
        for key in self.keys {
            key.frame = CGRect(x: offset, y: 0.0, width: width, height: height)
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