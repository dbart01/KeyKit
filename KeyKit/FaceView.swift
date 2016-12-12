//
//  FaceView.swift
//  KeyKit
//
//  Created by Dima Bart on 2016-01-27.
//  Copyright © 2016 Dima Bart. All rights reserved.
//

import UIKit

open class FaceView: UIView {
    
    open let face: Face
    open let rows: [RowView]
    
    // ----------------------------------
    //  MARK: - Init -
    //
    public init(face: Face, targetable: KeyTargetable) {
        self.face = face
        self.rows = face.rows.viewsWith(targetable)
        
        super.init(frame: CGRect.zero)
        
        self.addSubviews(self.rows)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // ----------------------------------
    //  MARK: - Layout -
    //
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        let height = self.bounds.height / CGFloat(self.rows.count)
        let width  = self.bounds.width
        var offset = CGFloat(0.0)
        
        for row in self.rows {
            row.frame = CGRect(x: 0.0, y: offset, width: width, height: height)
            offset   += row.frame.height
        }
    }
}

// ----------------------------------
//  MARK: - CollectionType -
//
private extension Collection where Iterator.Element == Row {
    func viewsWith(_ targetable: KeyTargetable) -> [RowView] {
        return self.map {
            RowView(row: $0, targetable: targetable)
        }
    }
}
