//
//  MountainShape.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 29/06/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import SwiftUI

struct MountainShape: Shape {

    struct Scale {
        let x: Double
        let y: Double
    }

    private let values: [Double]
    private let isClosedPath: Bool
    private let minY: CGFloat
    private let maxY: CGFloat

    init(values: [Double], isClosed closed: Bool = false) {
        self.values = values
        isClosedPath = closed
        minY = CGFloat(values.min() ?? .zero)
        maxY = CGFloat(values.max() ?? .zero)
    }

    func path(in rect: CGRect) -> Path {
        Path { path in
            path.addLines(points(in: rect))
        }
    }

    private func scale(in rect: CGRect) -> CGPoint {
        CGPoint(
            x: rect.size.width / max(1, CGFloat(values.count)),
            y: rect.size.height / max(1, maxY - minY)
        )
    }

    private func points(in rect: CGRect) -> [CGPoint] {
        let scale = self.scale(in: rect)
        let start = CGPoint(x: 0, y: rect.maxY)
        let end = CGPoint(x: rect.maxX, y: rect.maxY)
        let values = self.values.enumerated().map { index, value in
            CGPoint(x: CGFloat(index) * scale.x, y: rect.maxY - (CGFloat(value) - minY) * scale.y)
        }
        if isClosedPath {
            return [start] + values + [end]
        } else {
            return values
        }
    }
}
