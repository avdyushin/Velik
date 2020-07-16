//
//  MountainShape.swift
//  Velik
//
//  Created by Grigory Avdyushin on 29/06/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import SwiftUI

struct MountainShape<Filter: InputProcessor>: Shape where Filter.Input == Double, Filter.Output == Double {

    typealias AnimatableData = AnimatablePair<CGFloat, CGFloat>

    private let values: [Double]
    private let isClosedPath: Bool
    private let axis: Axis

    var animatableData: AnimatableData = .zero

    init(values: [Double], scale: AnimatableData, filter: Filter? = nil, isClosed closed: Bool = false) {
        if let filter = filter {
            self.values = values.map { filter.process(input: $0) }
        } else {
            self.values = values
        }
        self.isClosedPath = closed
        self.animatableData = scale
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
        let values = axis.convert(
            values: self.values,
            in: rect.size,
            scale: CGPoint(x: animatableData.first, y: animatableData.second)
        )
        if isClosedPath {
            let start = CGPoint(x: 0, y: rect.maxY)
            let end = CGPoint(x: rect.maxX, y: rect.maxY)
            return [start] + values + [end]
        } else {
            return values
        }
    }
}
