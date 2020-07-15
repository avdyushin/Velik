//
//  CGContext+Extensions.swift
//  Velik
//
//  Created by Grigory Avdyushin on 23/06/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import CoreGraphics

extension CGContext {
    func draw(_ block: (CGContext) -> Void) {
        defer { restoreGState() }
        saveGState()
        block(self)
    }
}
