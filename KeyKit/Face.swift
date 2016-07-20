//
//  Face.swift
//  KeyKit
//
//  Created by Dima Bart on 2016-01-27.
//  Copyright © 2016 Dima Bart. All rights reserved.
//

import Foundation

public struct Face {
    
    let identifier: String
    
    private(set) var rows: [Row] = []
    
    // ----------------------------------
    //  MARK: - Init -
    //
    public init(identifier: String) {
        self.identifier = identifier
    }
    
    public init(identifier: String, rows: [Row]) {
        self.init(identifier: identifier)
        
        self.rows = rows
    }
    
    // ----------------------------------
    //  MARK: - Mutation -
    //
    public mutating func add(row: Row) {
        self.rows.append(row)
    }
    
    public mutating func add(rows: [Row]) {
        self.rows.appendContentsOf(rows)
    }
    
    public mutating func remove(rows: Row) {
        if let index = self.rows.indexOf(rows) {
            self.rows.removeAtIndex(index)
        }
    }
}

