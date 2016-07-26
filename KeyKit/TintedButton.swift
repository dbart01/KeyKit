//
//  TintedButton.swift
//  KeyKit
//
//  Created by Dima Bart on 2016-07-26.
//  Copyright © 2016 Dima Bart. All rights reserved.
//

import UIKit

public class TintedButton: UIButton {
    
    // ----------------------------------
    //  MARK: - States -
    //
    public override var selected: Bool {
        didSet {
            self.updateTintForState()
        }
    }
    
    public override var highlighted: Bool {
        didSet {
            self.updateTintForState()
        }
    }
    
    public override func setTitleColor(color: UIColor?, forState state: UIControlState) {
        super.setTitleColor(color, forState: state)
        self.updateTintForState()
    }
    
    // ----------------------------------
    //  MARK: - Updates -
    //
    private func updateTintForState() {
        self.tintColor = self.titleColorForState(self.state)
    }
}
