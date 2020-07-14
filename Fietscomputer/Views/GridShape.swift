//
//  GridShape.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 04/07/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import SwiftUI

struct GridShape: Shape {

    let viewModel: GridShapeViewModel

    func path(in rect: CGRect) -> Path {
        Path { path in
            if viewModel.position.contains(.leading) {
                yAxis(path: &path, in: rect)
            }
            if viewModel.position.contains(.bottom) {
                xAxis(path: &path, in: rect)
            }
        }
    }

    private func yAxis(path: inout Path, in rect: CGRect) {
        viewModel.yValues(in: rect.size)
            .map { $0.point }
            .forEach { point in
                path.move(to: point)
                path.addLine(to: point.applying(.init(translationX: viewModel.gridSize.width / 2, y: 0)))
            }
    }

    private func xAxis(path: inout Path, in rect: CGRect) {
        viewModel.xValues(in: rect.size)
            .map { $0.point }
            .forEach { point in
                path.move(to: point)
                path.addLine(to: point.applying(.init(translationX: 0, y: -viewModel.gridSize.height / 2)))
            }
    }
}
