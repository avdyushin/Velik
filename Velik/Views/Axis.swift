//
//  Axis.swift
//  Velik
//
//  Created by Grigory Avdyushin on 30/06/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import struct CoreGraphics.CGRect
import struct CoreGraphics.CGSize
import struct CoreGraphics.CGFloat
import struct CoreGraphics.CGPoint

struct Axis {

    let minX: CGFloat
    let maxX: CGFloat
    let minY: CGFloat
    let maxY: CGFloat

    func scale(in size: CGSize) -> CGPoint {
        CGPoint(
            x: size.width / max(1, maxX),
            y: size.height / max(1, maxY - minY)
        )
    }

    func convert(point: CGPoint, in size: CGSize, scale: CGPoint = CGPoint(x: 1, y: 1)) -> CGPoint {
        let scale = self.scale(in: size.scaled(by: scale))
        return CGPoint(
            x: point.x * scale.x,
            y: size.height - (point.y - minY) * scale.y
        )
    }

    func convert(values: [Double], in size: CGSize, scale: CGPoint = CGPoint(x: 1, y: 1)) -> [CGPoint] {
        values.enumeratedCGPoints().map { convert(point: $0, in: size, scale: scale) }
    }
}
