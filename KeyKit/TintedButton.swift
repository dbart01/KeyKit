//
//  TintedButton.swift
//  KeyKit
//
//  Created by Dima Bart on 2016-07-26.
//  Copyright © 2016 Dima Bart. All rights reserved.
//

import UIKit

open class TintedButton: UIButton {
    
    // ----------------------------------
    //  MARK: - States -
    //
    open override var isSelected: Bool {
        didSet {
            self.updateTintForState()
        }
    }
    
    open override var isHighlighted: Bool {
        didSet {
            self.updateTintForState()
        }
    }
    
    open override func setTitleColor(_ color: UIColor?, for state: UIControlState) {
        super.setTitleColor(color, for: state)
        self.updateTintForState()
    }
    
    // ----------------------------------
    //  MARK: - Updates -
    //
    private func updateTintForState() {
        self.tintColor = self.titleColor(for: self.state)
    }
}
