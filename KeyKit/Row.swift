//
//  Row.swift
//  KeyKit
//
//  Created by Dima Bart on 2016-01-27.
//  Copyright © 2016 Dima Bart. All rights reserved.
//

import Foundation

public struct Row: Equatable {
    
    private(set) var keys: [Key] = []
    
    // ----------------------------------
    //  MARK: - Init -
    //
    public init() {
        
    }
    
    public init(keys: [Key]) {
        self.keys = keys
    }
    
    // ----------------------------------
    //  MARK: - Mutation -
    //
    public mutating func add(key: Key) {
        self.keys.append(key)
    }
    
    public mutating func add(keys: [Key]) {
        self.keys.appendContentsOf(keys)
    }
    
    public mutating func remove(key: Key) {
        if let index = self.keys.indexOf(key) {
            self.keys.removeAtIndex(index)
        }
    }
}

// ----------------------------------
//  MARK: - Equatable -
//
public func ==(lhs: Row, rhs: Row) -> Bool {
    return lhs.keys == rhs.keys
}
