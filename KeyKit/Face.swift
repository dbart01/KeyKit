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

// ----------------------------------
//  MARK: - Default Faces -
//
public extension Face {
    
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
                Key(label: .Char("B"), value: .Action(.Backspace)),
            ]),
            Row(keys: [
                Key(label: .Char("123"),    value: .Action(.ChangeFace(Identifier.Numbers))),
                Key(label: .Char("G"),      value: .Action(.Globe)),
                Key(label: .Char("_"),      value: .Char  (" ")),
                Key(label: .Char("return"), value: .Action(.Return)),
            ]),
        ])
    }
    
    public static func numbersFace() -> Face {
        return Face(identifier: Identifier.Numbers, rows: [
            Row(keys: [
                Key(label: "1", char: "1"),
                Key(label: "2", char: "2"),
                Key(label: "3", char: "3"),
                Key(label: "4", char: "4"),
                Key(label: "5", char: "5"),
                Key(label: "6", char: "6"),
                Key(label: "7", char: "7"),
                Key(label: "8", char: "8"),
                Key(label: "9", char: "9"),
                Key(label: "0", char: "0"),
            ]),
            Row(keys: [
                Key(label: "-",  char: "-"),
                Key(label: "/",  char: "/"),
                Key(label: ":",  char: ":"),
                Key(label: ";",  char: ";"),
                Key(label: "(",  char: "("),
                Key(label: ")",  char: ")"),
                Key(label: "$",  char: "$"),
                Key(label: "&",  char: "&"),
                Key(label: "@",  char: "@"),
                Key(label: "\"", char: "\""),
            ]),
            Row(keys: [
                Key(label: .Char("#+="), value: .Action(.ChangeFace(Identifier.Characters))),
                Key(label: ".", char: "."),
                Key(label: ",", char: ","),
                Key(label: "?", char: "?"),
                Key(label: "!", char: "!"),
                Key(label: "'", char: "'"),
                Key(label: .Char("B"), value: .Action(.Backspace)),
            ]),
            Row(keys: [
                Key(label: .Char("ABC"),    value: .Action(.ChangeFace(Identifier.Letters))),
                Key(label: .Char("G"),      value: .Action(.Globe)),
                Key(label: .Char("_"),      value: .Char  (" ")),
                Key(label: .Char("return"), value: .Action(.Return)),
            ]),
        ])
    }
    
    public static func charactersFace() -> Face {
        return Face(identifier: Identifier.Characters, rows: [
            Row(keys: [
                Key(label: "[", char: "["),
                Key(label: "]", char: "]"),
                Key(label: "{", char: "{"),
                Key(label: "}", char: "}"),
                Key(label: "#", char: "#"),
                Key(label: "%", char: "%"),
                Key(label: "^", char: "^"),
                Key(label: "*", char: "*"),
                Key(label: "+", char: "+"),
                Key(label: "=", char: "="),
            ]),
            Row(keys: [
                Key(label: "_",        char: "-"),
                Key(label: "\\",       char: "\\"),
                Key(label: "|",        char: ":"),
                Key(label: "~",        char: ";"),
                Key(label: "<",        char: "("),
                Key(label: ">",        char: "("),
                Key(label: "$",        char: "$"),
                Key(label: "\u{20AC}", char: "\u{20AC}"),
                Key(label: "\u{00A3}", char: "\u{00A3}"),
                Key(label: "\u{00A5}", char: "\u{00A5}"),
                Key(label: "\u{2022}", char: "\u{2022}"),
            ]),
            Row(keys: [
                Key(label: .Char("123"), value: .Action(.ChangeFace(Identifier.Numbers))),
                Key(label: ".", char: "."),
                Key(label: ",", char: ","),
                Key(label: "?", char: "?"),
                Key(label: "!", char: "!"),
                Key(label: "'", char: "'"),
                Key(label: .Char("B"), value: .Action(.Backspace)),
            ]),
            Row(keys: [
                Key(label: .Char("ABC"),    value: .Action(.ChangeFace(Identifier.Letters))),
                Key(label: .Char("G"),      value: .Action(.Globe)),
                Key(label: .Char("_"),      value: .Char  (" ")),
                Key(label: .Char("return"), value: .Action(.Return)),
            ]),
        ])
    }
}
