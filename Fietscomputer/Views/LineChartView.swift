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
    let viewModel: GridShapeViewModel
    let filter: Filter

    init(xValues: [Double], yValues: [Double], fillStyle: FillStyle) {
        self.xValues = xValues
        self.yValues = yValues
        self.fillStyle = fillStyle
        self.viewModel = GridShapeViewModel(
            x: XAxisDistance(distance: xValues.max() ?? .zero, maxCount: 10),
            y: YAxisValues(min: yValues.min() ?? .zero, max: yValues.max() ?? .zero, maxCount: 5),
            gridSize: CGSize(width: 32, height: 16),
            position: [.leading, .bottom]
        )
        self.filter = LowPassFilter(initialValue: yValues.first, factor: 0.2)
    }

    @State private var scale = MountainShape.AnimatableData(1.0, 0.0)

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                ZStack {
                    MountainShape(values: self.yValues, scale: self.scale, filter: self.filter, isClosed: true)
                        .fill(self.fillStyle)
                        .onAppear { self.scale = MountainShape.AnimatableData(1.0, 1.0) }
                        .padding(.bottom, self.viewModel.gridSize.height)
                        .padding(.leading, self.viewModel.gridSize.width)
                    GridShape(viewModel: self.viewModel)
                        .stroke(Color.gray.opacity(0.3))
                }
            }
        }
    }
}
