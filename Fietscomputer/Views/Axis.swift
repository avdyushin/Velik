//
//  Axis.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 30/06/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import struct CoreGraphics.CGFloat
import struct CoreGraphics.CGPoint
import struct CoreGraphics.CGRect

struct Axis {

    let minX: CGFloat
    let maxX: CGFloat
    let minY: CGFloat
    let maxY: CGFloat

    private func scale(in rect: CGRect) -> CGPoint {
        CGPoint(
            x: rect.size.width / max(1, maxX),
            y: rect.size.height / max(1, maxY - minY)
        )
    }

    func convert(point: CGPoint, in rect: CGRect, scale: CGPoint) -> CGPoint {
        let scale = self.scale(in: rect.scaled(by: scale))
        return CGPoint(
            x: point.x * scale.x,
            y: rect.maxY - (point.y - minY) * scale.y
        )
    }

    func convert(values: [Double], in rect: CGRect, scale: CGPoint) -> [CGPoint] {
        values.enumeratedCGPoints().map { convert(point: $0, in: rect, scale: scale) }
    }
}
