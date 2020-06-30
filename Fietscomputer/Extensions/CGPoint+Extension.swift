//
//  CGPoint+Extension.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 30/06/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import struct CoreGraphics.CGPoint
import struct CoreGraphics.CGRect
import struct CoreGraphics.CGSize

extension CGRect {
    func scaled(by scale: CGPoint) -> CGRect {
        CGRect(origin: origin, size: CGSize(width: size.width * scale.x, height: size.height * scale.y))
    }
}
