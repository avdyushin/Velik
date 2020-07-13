//
//  LineChartView.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 27/06/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import SwiftUI
import CoreLocation

struct LineChartView<FillStyle: ShapeStyle>: View {

    let xValues: [Double]
    let yValues: [Double]
    let fillStyle: FillStyle

    @State private var scale = MountainShape.AnimatableData(1.0, 0.0)

    private let gridSize = CGSize(width: 32, height: 16)

    var body: some View {
        ZStack {
            MountainShape(values: yValues, scale: scale, isClosed: true)
                .fill(fillStyle)
                .onAppear { self.scale = MountainShape.AnimatableData(1.0, 1.0) }
                .padding(.bottom, gridSize.height)
                .padding(.leading, gridSize.width)
            GridShape(viewModel: GridShapeViewModel(
                xValues: xValues,
                yValues: yValues,
                gridSize: gridSize,
                position: [.leading, .bottom]
            ))
                .stroke(Color.red, lineWidth: 3)
                //.stroke(Color.gray.opacity(0.3))
        }
    }
}
