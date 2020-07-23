//
//  GridShapeViewModel.swift
//  Velik
//
//  Created by Grigory Avdyushin on 13/07/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import UIKit
import SwiftUI

class GridShapeViewModel<UnitType: Unit> {

    struct PointValue {
        let value: Double
        let point: CGPoint
    }

    let gridSize: CGSize
    let position: Edge.Set
    let yValues: [Double]
    let xValues: [Double]

    let xMarkers: [Measurement<UnitLength>]
    let yMarkers: [Measurement<UnitType>]

    private let axis: Axis

    init(x: XAxisDistance, y: YAxisValues<UnitType>, gridSize: CGSize, position: Edge.Set) {
        self.xValues = x.values
        self.xMarkers = x.markers
        self.yValues = y.values
        self.yMarkers = y.markers
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
            .map {
                PointValue(value: $0.value, point: CGPoint(x: $0.point.x, y: size.height - 2 * gridSize.height / 3))
            }
    }

    func yValues(in size: CGSize) -> [PointValue] {
        yValues
            .map { PointValue(value: $0, point: convert(point: CGPoint(x: 0, y: $0), in: size)) }
            .map { PointValue(value: $0.value, point: CGPoint(x: 2 * gridSize.width / 3, y: $0.point.y)) }
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

    // Move to renderer

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
            let value = yMarkers[index]
            let string = NSAttributedString(string: Formatters.basicMeasurement.string(from: value), attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.black
            ])
            path.move(to: point)
            path.addLine(to: point.applying(.init(translationX: gridSize.width / 3, y: 0)))
            let offsetX = string.size().width
            let offsetY = string.size().height / 2
            string.draw(at: CGPoint(x: point.x - offsetX, y: point.y - offsetY))
        }
    }

    func xAxisImage(in size: CGSize) -> UIImage? {
        axisImage(values: xValues(in: size), in: size) { path, point, index in
            let value = DistanceUtils.string(for: xMarkers[index])
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
