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
    public mutating func add(_ row: Row) {
        self.rows.append(row)
    }
    
    public mutating func add(_ rows: [Row]) {
        self.rows.append(contentsOf: rows)
    }
    
    public mutating func remove(_ rows: Row) {
        if let index = self.rows.index(of: rows) {
            self.rows.remove(at: index)
        }
    }
}

extension Collection where Iterator.Element == Face {
    
    var dictionaryByIdentifier: [String : Face] {
        var container = [String : Face]()
        for face in self {
            container[face.identifier] = face
        }
        return container
    }
}

