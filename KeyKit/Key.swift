//
//  Key.swift
//  KeyKit
//
//  Created by Dima Bart on 2016-01-27.
//  Copyright © 2016 Dima Bart. All rights reserved.
//

import Foundation

public protocol KeyActionType {}

@objc public enum KeyStyle: Int {
    case Main
    case Alternate
    case Done
}

public struct Key: Equatable {
    
    public enum Label: Equatable {
        case Icon(String)
        case Char(String)
    }
    
    public enum Action: Equatable {
        case Shift
        case ChangeFace(String)
        case Backspace
        case Return
        case Globe
        case Custom(KeyActionType)
    }
    
    public enum Value: Equatable {
        case Action(Key.Action)
        case Char(String)
    }
    
    public var label:  Label
    public let value:  Value
    public let length: Double
    public let style:  KeyStyle
    
    // ----------------------------------
    //  MARK: - Init -
    //
    public init(label: Label, value: Value, length: Double, style: KeyStyle = .Main) {
        self.label  = label
        self.value  = value
        self.length = length
        self.style  = style
    }
    
    public init(label: String, char: String, length: Double) {
        self.init(label: .Char(label), value: .Char(char), length: length)
    }
    
    public init(label: String, action: Key.Action, length: Double, style: KeyStyle = .Main) {
        self.init(label: .Char(label), value: .Action(action), length: length, style: style)
    }
    
    public init(icon: String, char: String, length: Double) {
        self.init(label: .Icon(icon), value: .Char(char), length: length)
    }
}

// ----------------------------------
//  MARK: - Equatable -
//
public func ==(lhs: Key.Label, rhs: Key.Label) -> Bool {
    switch (lhs, rhs) {
    case (.Icon(let left), .Icon(let right)) where left == right:
        return true
    case (.Char(let left), .Char(let right)) where left == right:
        return true
    default:
        return false
    }
}

public func ==(lhs: Key.Action, rhs: Key.Action) -> Bool {
    switch (lhs, rhs) {
    case (.Shift,     .Shift):     return true
    case (.Backspace, .Backspace): return true
    case (.Return,    .Return):    return true
    case (.Globe,     .Globe):     return true
        
    case (.ChangeFace(let left), .ChangeFace(let right)) where left == right:
        return true
        
    default:
        return false
    }
}

public func ==(lhs: Key.Value, rhs: Key.Value) -> Bool {
    switch (lhs, rhs) {
    case (.Action(let left), .Action(let right)) where left == right:
        return true
    case (.Char(let left), .Char(let right)) where left == right:
        return true
    default:
        return false
    }
}

public func ==(lhs: Key, rhs: Key) -> Bool {
    return
        lhs.label  == rhs.label &&
        lhs.value  == rhs.value &&
        lhs.length == rhs.length &&
        lhs.style  == rhs.style
}
