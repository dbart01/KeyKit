//
//  Key.swift
//  KeyKit
//
//  Created by Dima Bart on 2016-01-27.
//  Copyright © 2016 Dima Bart. All rights reserved.
//

import Foundation

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
    }
    
    public enum Value: Equatable {
        case Action(Key.Action)
        case Char(String)
    }
    
    public enum Style {
        case Main
        case Alternate
    }
    
    public let label: Label
    public let value: Value
    public let style: Style
    
    // ----------------------------------
    //  MARK: - Init -
    //
    public init(label: Label, value: Value, style: Style = .Main) {
        self.label = label
        self.value = value
        self.style = style
    }
    
    public init(label: String, char: String) {
        self.init(label: .Char(label), value: .Char(char))
    }
    
    public init(icon: String, char: String) {
        self.init(label: .Icon(icon), value: .Char(char))
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
    return lhs.label == rhs.label && lhs.value == rhs.value
}
