//
//  UIReturnKeyType+Description.swift
//  KeyKit
//
//  Created by Jeffrey Deng on 2016-08-17.
//  Copyright © 2016 Dima Bart. All rights reserved.
//

import UIKit

extension UIReturnKeyType: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        switch self {
        case .Default:
            return "return"
        case .Go:
            return "go"
        case .Google:
            return "google"
        case .Join:
            return "join"
        case .Next:
            return "next"
        case .Route:
            return "route"
        case .Search:
            return "search"
        case .Send:
            return "send"
        case .Yahoo:
            return "yahoo"
        case .Done:
            return "done"
        case .EmergencyCall:
            return "emergency call"
        case .Continue:
            return "continue"
        }
    }
    
    public var debugDescription: String { return description }
}
