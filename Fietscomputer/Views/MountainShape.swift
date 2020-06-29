//
//  MountainShape.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 29/06/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import SwiftUI

fileprivate extension Collection where Element == Double {
    func asPoints() -> [CGPoint] {
        enumerated().map { CGPoint(x: Double($0), y: $1) }
    }
}

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

    func convert(point: CGPoint, in rect: CGRect, scaleY: CGFloat) -> CGPoint {
        let scale = self.scale(in: rect)
        return CGPoint(
            x: point.x * scale.x,
            y: rect.maxY - (point.y - minY) * scale.y * scaleY
        )
    }

    func convert(values: [Double], in rect: CGRect, scaleY: CGFloat) -> [CGPoint] {
        values.asPoints().map { convert(point: $0, in: rect, scaleY: scaleY) }
    }
}

struct MountainShape: Shape {

    private let values: [Double]
    private let isClosedPath: Bool
    private let axis: Axis
    private var scaleY: CGFloat

    var animatableData: CGFloat {
        get { scaleY }
        set { self.scaleY = newValue }
    }

    init(values: [Double], scaleY: CGFloat, isClosed closed: Bool = false) {
        self.values = values
        self.isClosedPath = closed
        self.scaleY = scaleY
        self.axis = Axis(
            minX: 0,
            maxX: CGFloat(max(1, values.count)),
            minY: CGFloat(values.min() ?? .zero),
            maxY: CGFloat(values.max() ?? .zero)
        )
    }

    func path(in rect: CGRect) -> Path {
        Path { path in
            path.addLines(points(in: rect))
        }
    }

    private func points(in rect: CGRect) -> [CGPoint] {
        let values = axis.convert(values: self.values, in: rect, scaleY: scaleY)
        if isClosedPath {
            let start = CGPoint(x: 0, y: rect.maxY)
            let end = CGPoint(x: rect.maxX, y: rect.maxY)
            return [start] + values + [end]
        } else {
            return values
        }
    }
}
