//
//  Key.swift
//  KeyKit
//
//  Created by Dima Bart on 2016-01-27.
//  Copyright © 2016 Dima Bart. All rights reserved.
//

import Foundation

public protocol KeyActionType {}

@objc public enum KeyStyle: Int32 {
    case main
    case alternate
    case done
}

public struct Key: Equatable {
    
    public enum Label: Equatable {
        case icon(String)
        case char(String)
    }
    
    public enum Action: Equatable {
        case shift
        case changeFace(String)
        case backspace
        case `return`
        case globe
        case custom(KeyActionType)
    }
    
    public enum Value: Equatable {
        case action(Key.Action)
        case char(String)
    }
    
    public let label:  Label
    public let value:  Value
    public let length: Double
    public let style:  KeyStyle
    
    // ----------------------------------
    //  MARK: - Init -
    //
    public init(label: Label, value: Value, length: Double, style: KeyStyle = .main) {
        self.label  = label
        self.value  = value
        self.length = length
        self.style  = style
    }
    
    public init(label: String, char: String, length: Double) {
        self.init(label: .char(label), value: .char(char), length: length)
    }
    
    public init(label: String, action: Key.Action, length: Double, style: KeyStyle = .main) {
        self.init(label: .char(label), value: .action(action), length: length, style: style)
    }
    
    public init(icon: String, char: String, length: Double) {
        self.init(label: .icon(icon), value: .char(char), length: length)
    }
}

// ----------------------------------
//  MARK: - Equatable -
//
public func ==(lhs: Key.Label, rhs: Key.Label) -> Bool {
    switch (lhs, rhs) {
    case (.icon(let left), .icon(let right)) where left == right:
        return true
    case (.char(let left), .char(let right)) where left == right:
        return true
    default:
        return false
    }
}

public func ==(lhs: Key.Action, rhs: Key.Action) -> Bool {
    switch (lhs, rhs) {
    case (.shift,     .shift):     return true
    case (.backspace, .backspace): return true
    case (.return,    .return):    return true
    case (.globe,     .globe):     return true
        
    case (.changeFace(let left), .changeFace(let right)) where left == right:
        return true
        
    default:
        return false
    }
}

public func ==(lhs: Key.Value, rhs: Key.Value) -> Bool {
    switch (lhs, rhs) {
    case (.action(let left), .action(let right)) where left == right:
        return true
    case (.char(let left), .char(let right)) where left == right:
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
