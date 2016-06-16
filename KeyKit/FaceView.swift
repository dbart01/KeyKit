//
//  FaceView.swift
//  KeyKit
//
//  Created by Dima Bart on 2016-01-27.
//  Copyright © 2016 Dima Bart. All rights reserved.
//

import UIKit

public class FaceView: UIView {
    
    public let face: Face
    public let rows: [RowView]
    
    // ----------------------------------
    //  MARK: - Init -
    //
    public init(face: Face, targetable: KeyTargetable) {
        self.face = face
        self.rows = face.rows.viewsWith(targetable)
        
        super.init(frame: CGRectZero)
        
        self.addSubviews(self.rows)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // ----------------------------------
    //  MARK: - Layout -
    //
    public override func layoutSubviews() {
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
private extension CollectionType where Generator.Element == Row {
    private func viewsWith(targetable: KeyTargetable) -> [RowView] {
        return self.map {
            RowView(row: $0, targetable: targetable)
        }
    }
}
