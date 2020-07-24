//
//  GridShapeViewModel.swift
//  Velik
//
//  Created by Grigory Avdyushin on 13/07/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import UIKit
import SwiftUI

class GridShapeViewModel<X: AxisValuesProvider, Y: AxisValuesProvider> {

    struct PointValue {
        let value: Double
        let point: CGPoint
    }

    let xAxis: X
    let yAxis: Y
    let gridSize: CGSize
    let position: Edge.Set

    private let axis: Axis

    init(x: X, y: Y, gridSize: CGSize, position: Edge.Set) {
        self.xAxis = x
        self.yAxis = y
        self.gridSize = gridSize
        self.position = position

        self.axis = Axis(
            minX: 0,
            maxX: CGFloat(max(1, x.values.max() ?? .zero)),
            minY: CGFloat(y.values.min() ?? .zero),
            maxY: CGFloat(y.values.max() ?? .zero)
        )
    }

    func xValues(in size: CGSize) -> [PointValue] {
        xAxis.values
            .dropLast()
            .map { PointValue(value: $0, point: convert(point: CGPoint(x: $0, y: 0), in: size)) }
            .map {
                PointValue(value: $0.value, point: CGPoint(x: $0.point.x, y: size.height - 2 * gridSize.height / 3))
            }
    }

    func yValues(in size: CGSize) -> [PointValue] {
        yAxis.values
            .map { PointValue(value: $0, point: convert(point: CGPoint(x: 0, y: $0), in: size)) }
            .map { PointValue(value: $0.value, point: CGPoint(x: 0.9 * gridSize.width, y: $0.point.y)) }
    }

    func stepX(in size: CGSize) -> CGFloat {
        guard xAxis.values.count > 1 else {
            return 0
        }
        let xScale = axis.scale(in: chartSize(in: size)).x
        let step = xAxis.values[1] - xAxis.values[0]
        return CGFloat(step) * xScale
    }

    // TODO: Move to renderer
    typealias Index = Int
    typealias DrawBlock = (CGMutablePath, CGPoint, Index) -> Void

    func axisImage(values: [PointValue], in size: CGSize, draw: DrawBlock) -> UIImage? {
        defer {
             UIGraphicsEndImageContext()
         }

        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)

        guard let context = UIGraphicsGetCurrentContext() else {
            return UIGraphicsGetImageFromCurrentImageContext()
        }

        context.draw { context in

            context.setLineWidth(1)
            context.setLineCap(.square)
            context.setStrokeColor(UIColor.black.cgColor)

            values
                .enumerated()
                .forEach { index, pair in
                    let point = pair.point
                    let path = CGMutablePath()
                    draw(path, point, index)
                    context.addPath(path)
                }
            context.strokePath()
        }

        return UIGraphicsGetImageFromCurrentImageContext()?
            .withRenderingMode(.alwaysTemplate)
    }

    func yAxisImage(in size: CGSize) -> UIImage? {
        axisImage(values: yValues(in: size), in: size) { path, point, index in
            // Skip max value to display
            guard index != yAxis.values.count - 1 else { return }
            let value =  yAxis.format(at: index)
            let string = NSAttributedString(string: value, attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.black
            ])
            path.move(to: point)
            path.addLine(to: point.applying(.init(translationX: 0.1 * gridSize.width, y: 0)))
            let offsetX = string.size().width + 4
            let offsetY = string.size().height / 2
            string.draw(at: CGPoint(x: point.x - offsetX, y: point.y - offsetY))
        }
    }

    func xAxisImage(in size: CGSize) -> UIImage? {
        axisImage(values: xValues(in: size), in: size) { path, point, index in
            let value = xAxis.format(at: index)
            let string = NSAttributedString(string: value, attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.black
            ])
            path.move(to: point)
            path.addLine(to: point.applying(.init(translationX: 0, y: -gridSize.height / 2)))
            let offsetX = string.size().width / 2
            string.draw(at: CGPoint(x: point.x - offsetX, y: point.y))
        }
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
