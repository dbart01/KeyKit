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
    //  MARK: - Faces -
    //
    public static func lettersFace() -> Face {
        return Face(identifier: Identifier.Letters, rows: [
            Row(keys: [
                Key(label: "Q", char: "q"),
                Key(label: "W", char: "w"),
                Key(label: "E", char: "e"),
                Key(label: "R", char: "r"),
                Key(label: "T", char: "t"),
                Key(label: "Y", char: "y"),
                Key(label: "U", char: "u"),
                Key(label: "I", char: "i"),
                Key(label: "O", char: "o"),
                Key(label: "P", char: "p"),
            ]),
            Row(keys: [
                Key(label: "A", char: "a"),
                Key(label: "S", char: "s"),
                Key(label: "D", char: "d"),
                Key(label: "F", char: "f"),
                Key(label: "G", char: "g"),
                Key(label: "H", char: "h"),
                Key(label: "J", char: "j"),
                Key(label: "K", char: "k"),
                Key(label: "L", char: "l"),
            ]),
            Row(keys: [
                Key(label: .Char("S"), value: .Action(.Shift)),
                Key(label: "Z", char: "z"),
                Key(label: "X", char: "x"),
                Key(label: "C", char: "c"),
                Key(label: "V", char: "v"),
                Key(label: "B", char: "b"),
                Key(label: "N", char: "n"),
                Key(label: "M", char: "m"),
                Key(label: .Char("B"), value: .Action(.Shift)),
            ]),
            Row(keys: [
                Key(label: .Char("123"),    value: .Action(.ChangeFace)),
                Key(label: .Char("G"),      value: .Action(.Globe)),
                Key(label: .Char("_"),      value: .Char  (" ")),
                Key(label: .Char("return"), value: .Action(.Return)),
            ]),
        ])
    }
    
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