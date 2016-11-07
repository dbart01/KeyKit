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
    public mutating func add(_ key: Key) {
        self.keys.append(key)
    }
    
    public mutating func add(_ keys: [Key]) {
        self.keys.append(contentsOf: keys)
    }
    
    public mutating func remove(_ key: Key) {
        if let index = self.keys.index(of: key) {
            self.keys.remove(at: index)
        }
    }
}

// ----------------------------------
//  MARK: - Equatable -
//
public func ==(lhs: Row, rhs: Row) -> Bool {
    return lhs.keys == rhs.keys
}
