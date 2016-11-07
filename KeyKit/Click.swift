//
//  Click.swift
//  KeyKit
//
//  Created by Dima Bart on 2016-06-20.
//  Copyright © 2016 Dima Bart. All rights reserved.
//

import Foundation
import AudioToolbox

struct Click {
    static func play() {
        AudioServicesPlaySystemSound(1104)
    }
}