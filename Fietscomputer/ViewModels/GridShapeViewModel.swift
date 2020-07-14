//
//  GridShapeViewModel.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 13/07/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import SwiftUI

class GridShapeViewModel {

    struct PointValue {
        let value: Double
        let point: CGPoint
    }

    let gridSize: CGSize
    let position: Edge.Set
    let yValues: [Double]
    let xValues: [Double]

    private let axis: Axis

    init(x: AxisValuesProvider, y: AxisValuesProvider, gridSize: CGSize, position: Edge.Set) {
        self.xValues = x.values
        self.yValues = y.values
        self.gridSize = gridSize
        self.position = position

        self.axis = Axis(
            minX: 0,
            maxX: CGFloat(max(1, xValues.max() ?? .zero)),
            minY: CGFloat(yValues.min() ?? .zero),
            maxY: CGFloat(yValues.max() ?? .zero)
        )
    }

    func xValues(in size: CGSize) -> [PointValue] {
        xValues
            .dropLast()
            .map { PointValue(value: $0, point: convert(point: CGPoint(x: $0, y: 0), in: size)) }
            .map { PointValue(value: $0.value, point: CGPoint(x: $0.point.x, y: size.height - gridSize.height / 2)) }
    }

    func yValues(in size: CGSize) -> [PointValue] {
        yValues
            .map { PointValue(value: $0, point: convert(point: CGPoint(x: 0, y: $0), in: size)) }
            .map { PointValue(value: $0.value, point: CGPoint(x: gridSize.width / 2, y: $0.point.y)) }
    }

    func maxX(in size: CGSize) -> CGFloat {
        let xScale = axis.scale(in: chartSize(in: size)).x
        let trailing = xValues.dropLast().last ?? .zero
        return CGFloat(trailing) * xScale
    }

    func stepX(in size: CGSize) -> CGFloat {
        guard xValues.count > 1 else {
            return 0
        }
        let xScale = axis.scale(in: chartSize(in: size)).x
        let step = xValues[1] - xValues[0]
        return CGFloat(step) * xScale
    }

    private func chartSize(in size: CGSize) -> CGSize {
        CGSize(
            width: size.width - gridSize.width,
            height: size.height - gridSize.height
        )
    }

    private func convert(point: CGPoint, in size: CGSize) -> CGPoint {
        axis.convert(point: point, in: chartSize(in: size))
            .applying(.init(translationX: gridSize.width, y: 0))
    }
}
