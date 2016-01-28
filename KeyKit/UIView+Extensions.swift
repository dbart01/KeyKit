//
//  UIView+Extensions.swift
//  KeyKit
//
//  Created by Dima Bart on 2016-01-27.
//  Copyright © 2016 Dima Bart. All rights reserved.
//

import UIKit

internal extension UIView {
    
    func addSubviews(views: [UIView]) {
        for view in views {
            self.addSubview(view)
        }
    }
}
