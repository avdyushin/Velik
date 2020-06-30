//
//  LineChartView.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 27/06/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import SwiftUI
import CoreLocation

struct GridShape: Shape {

    let size: CGSize
    let position: Edge.Set

    private let axis: Axis

    init(values: [Double], size: CGSize, position: Edge.Set) {
        self.size = size
        self.position = position
        self.axis = Axis(
            minX: 0,
            maxX: CGFloat(max(1, values.count)),
            minY: CGFloat(values.min() ?? .zero),
            maxY: CGFloat(values.max() ?? .zero)
        )
    }

    func path(in rect: CGRect) -> Path {
        Path { path in
            if position.contains(.leading) {
                yAxis(path: &path, in: rect)
            }
            if position.contains(.bottom) {
                xAxis(path: &path, in: rect)
            }
        }
    }

    func chartRect(in rect: CGRect) -> CGRect {
        CGRect(
            x: rect.origin.x,
            y: rect.origin.y,
            width: rect.size.width - size.width,
            height: rect.size.height - size.height
        )
    }

    func convert(point: CGPoint, in rect: CGRect) -> CGPoint {
        axis.convert(point: point, in: chartRect(in: rect))
            .applying(.init(translationX: size.width, y: 0))
    }

    private func yAxis(path: inout Path, in rect: CGRect) {
        for offset in stride(from: 0, to: rect.size.height, by: rect.size.height / 5) {
            let point = CGPoint(x: rect.origin.x, y: offset)
            path.move(to: point)
            path.addLine(to: point.applying(.init(translationX: size.width, y: 0)))
        }
    }

    private func xAxis(path: inout Path, in rect: CGRect) {
        for offset in stride(from: size.width, to: rect.size.width, by: rect.size.width / 7) {
            let point = CGPoint(x: offset, y: rect.maxY)
            path.move(to: point)
            path.addLine(to: point.applying(.init(translationX: 0, y: -size.height)))
        }
    }
}

struct LineChartView<S: ShapeStyle>: View {

    let values: [Double]
    let fillStyle: S

    @State private var scale = MountainShape.AnimatableData(1.0, 0.0)

    private let gridSize = CGSize(width: 32, height: 16)

    var body: some View {
        ZStack {
            MountainShape(values: self.values, scale: self.scale, isClosed: true)
                .fill(self.fillStyle)
                .onAppear { self.scale = AnimatablePair(1.0, 1.0) }
                .padding(.bottom, gridSize.height)
            GridShape(values: self.values, size: gridSize, position: .bottom)
                .stroke(Color.gray.opacity(0.3))
        }
    }
}
