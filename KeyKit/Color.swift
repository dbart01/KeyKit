//
//  Color.swift
//  KeyKit
//
//  Created by Dima Bart on 2016-06-23.
//  Copyright © 2016 Dima Bart. All rights reserved.
//

import UIKit

internal struct Color {
    static func rgb(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        return self.rgba(r: r, g: g, b: b, a: 1.0)
    }
    
    static func rgba(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) -> UIColor {
        return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
    }
}
