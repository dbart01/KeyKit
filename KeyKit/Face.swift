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
                Key(label: "Q", char: "q", length: 10.00),
                Key(label: "W", char: "w", length: 10.00),
                Key(label: "E", char: "e", length: 10.00),
                Key(label: "R", char: "r", length: 10.00),
                Key(label: "T", char: "t", length: 10.00),
                Key(label: "Y", char: "y", length: 10.00),
                Key(label: "U", char: "u", length: 10.00),
                Key(label: "I", char: "i", length: 10.00),
                Key(label: "O", char: "o", length: 10.00),
                Key(label: "P", char: "p", length: 10.00),
            ]),
            Row(keys: [
                Key(label: "A", char: "a", length: 10.00),
                Key(label: "S", char: "s", length: 10.00),
                Key(label: "D", char: "d", length: 10.00),
                Key(label: "F", char: "f", length: 10.00),
                Key(label: "G", char: "g", length: 10.00),
                Key(label: "H", char: "h", length: 10.00),
                Key(label: "J", char: "j", length: 10.00),
                Key(label: "K", char: "k", length: 10.00),
                Key(label: "L", char: "l", length: 10.00),
            ]),
            Row(keys: [
                Key(label: "S", action: .Shift,     length: 11.20, style: .Alternate),
                Key(label: "Z", char: "z",          length: 10.00),
                Key(label: "X", char: "x",          length: 10.00),
                Key(label: "C", char: "c",          length: 10.00),
                Key(label: "V", char: "v",          length: 10.00),
                Key(label: "B", char: "b",          length: 10.00),
                Key(label: "N", char: "n",          length: 10.00),
                Key(label: "M", char: "m",          length: 10.00),
                Key(label: "B", action: .Backspace, length: 11.20, style: .Alternate),
            ]),
            Row(keys: [
                Key(label: .Char("123"),    value: .Action(.ChangeFace(Identifier.Numbers)), length: 11.20, style: .Alternate),
                Key(label: .Char("G"),      value: .Action(.Globe),                          length: 11.20, style: .Alternate),
                Key(label: .Char("space"),  value: .Char  (" "),                             length: 55.20),
                Key(label: .Char("return"), value: .Action(.Return),                         length: 22.40, style: .Done),
            ]),
        ])
    }
    
    public static func numbersFace() -> Face {
        return Face(identifier: Identifier.Numbers, rows: [
            Row(keys: [
                Key(label: "1", char: "1", length: 10.00),
                Key(label: "2", char: "2", length: 10.00),
                Key(label: "3", char: "3", length: 10.00),
                Key(label: "4", char: "4", length: 10.00),
                Key(label: "5", char: "5", length: 10.00),
                Key(label: "6", char: "6", length: 10.00),
                Key(label: "7", char: "7", length: 10.00),
                Key(label: "8", char: "8", length: 10.00),
                Key(label: "9", char: "9", length: 10.00),
                Key(label: "0", char: "0", length: 10.00),
            ]),
            Row(keys: [
                Key(label: "-",  char: "-",  length: 10.00),
                Key(label: "/",  char: "/",  length: 10.00),
                Key(label: ":",  char: ":",  length: 10.00),
                Key(label: ";",  char: ";",  length: 10.00),
                Key(label: "(",  char: "(",  length: 10.00),
                Key(label: ")",  char: ")",  length: 10.00),
                Key(label: "&",  char: "&",  length: 10.00),
                Key(label: "@",  char: "@",  length: 10.00),
                Key(label: "\"", char: "\"", length: 10.00),
            ]),
            Row(keys: [
                Key(label: "#+=", action: .ChangeFace(Identifier.Characters), length: 11.20, style: .Alternate),
                Key(label: ".",   char: ".",                                  length: 12.40),
                Key(label: ",",   char: ",",                                  length: 12.40),
                Key(label: "?",   char: "?",                                  length: 12.40),
                Key(label: "!",   char: "!",                                  length: 12.40),
                Key(label: "'",   char: "'",                                  length: 12.40),
                Key(label: "B",   action: .Backspace,                         length: 11.20, style: .Alternate),
            ]),
            Row(keys: [
                Key(label: .Char("ABC"),    value: .Action(.ChangeFace(Identifier.Letters)), length: 11.20, style: .Alternate),
                Key(label: .Char("G"),      value: .Action(.Globe),                          length: 11.20, style: .Alternate),
                Key(label: .Char("space"),  value: .Char  (" "),                             length: 55.20),
                Key(label: .Char("return"), value: .Action(.Return),                         length: 22.40, style: .Done),
            ]),
        ])
    }
    
    public static func charactersFace() -> Face {
        return Face(identifier: Identifier.Characters, rows: [
            Row(keys: [
                Key(label: "[", char: "[",  length: 10.00),
                Key(label: "]", char: "]",  length: 10.00),
                Key(label: "{", char: "{",  length: 10.00),
                Key(label: "}", char: "}",  length: 10.00),
                Key(label: "#", char: "#",  length: 10.00),
                Key(label: "%", char: "%",  length: 10.00),
                Key(label: "^", char: "^",  length: 10.00),
                Key(label: "*", char: "*",  length: 10.00),
                Key(label: "+", char: "+",  length: 10.00),
                Key(label: "=", char: "=",  length: 10.00),
            ]),
            Row(keys: [
                Key(label: "_",        char: "-",        length: 10.00),
                Key(label: "\\",       char: "\\",       length: 10.00),
                Key(label: "|",        char: ":",        length: 10.00),
                Key(label: "~",        char: ";",        length: 10.00),
                Key(label: "<",        char: "(",        length: 10.00),
                Key(label: ">",        char: "(",        length: 10.00),
                Key(label: "\u{20AC}", char: "\u{20AC}", length: 10.00),
                Key(label: "\u{00A3}", char: "\u{00A3}", length: 10.00),
                Key(label: "\u{00A5}", char: "\u{00A5}", length: 10.00),
                Key(label: "\u{2022}", char: "\u{2022}", length: 10.00),
            ]),
            Row(keys: [
                Key(label: "123", action: .ChangeFace(Identifier.Numbers), length: 11.20, style: .Alternate),
                Key(label: ".",   char: ".",                               length: 12.40),
                Key(label: ",",   char: ",",                               length: 12.40),
                Key(label: "?",   char: "?",                               length: 12.40),
                Key(label: "!",   char: "!",                               length: 12.40),
                Key(label: "'",   char: "'",                               length: 12.40),
                Key(label: "B",   action: .Backspace,                      length: 11.20, style: .Alternate),
            ]),
            Row(keys: [
                Key(label: .Char("ABC"),    value: .Action(.ChangeFace(Identifier.Letters)), length: 11.20, style: .Alternate),
                Key(label: .Char("G"),      value: .Action(.Globe),                          length: 11.20, style: .Alternate),
                Key(label: .Char("space"),  value: .Char  (" "),                             length: 55.20),
                Key(label: .Char("return"), value: .Action(.Return),                         length: 22.40, style: .Done),
            ]),
        ])
    }
}
