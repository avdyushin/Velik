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

    private let axis: Axis
    private let yValues: [Double]
    private let xValues: [Double]

    init(xValues: [Double], yValues: [Double], gridSize: CGSize, position: Edge.Set) {
        self.xValues = xValues
        self.yValues = yValues
        self.gridSize = gridSize
        self.position = position

        self.axis = Axis(
            minX: 0,
            maxX: CGFloat(max(1, xValues.max() ?? .zero)),
            minY: CGFloat(yValues.min() ?? .zero),
            maxY: CGFloat(yValues.max() ?? .zero)
        )
    }

    func xValues(in rect: CGRect) -> [PointValue] {
        xValues
            .map { PointValue(value: $0, point: convert(point: CGPoint(x: $0, y: 0), in: rect)) }
            .map { PointValue(value: $0.value, point: CGPoint(x: $0.point.x, y: rect.maxY - gridSize.height / 2)) }
    }

    func yValues(in rect: CGRect) -> [PointValue] {
        yValues
            .map { PointValue(value: $0, point: convert(point: CGPoint(x: 0, y: $0), in: rect)) }
            .map { PointValue(value: $0.value, point: CGPoint(x: gridSize.width / 2, y: $0.point.y)) }
    }

    private func chartRect(in rect: CGRect) -> CGRect {
        CGRect(
            x: rect.origin.x,
            y: rect.origin.y,
            width: rect.size.width - gridSize.width,
            height: rect.size.height - gridSize.height
        )
    }

    private func convert(point: CGPoint, in rect: CGRect) -> CGPoint {
        axis.convert(point: point, in: chartRect(in: rect))
            .applying(.init(translationX: gridSize.width, y: 0))
    }
}
