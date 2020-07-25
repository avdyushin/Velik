//
//  LineChartView.swift
//  Velik
//
//  Created by Grigory Avdyushin on 27/06/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import SwiftUI
import CoreLocation

struct LineChartView<FillStyle: ShapeStyle, Filter: InputProcessor, UnitType: Dimension>: View
where Filter.Input == Double, Filter.Output == Double {

    let xValues: [Double]
    let yValues: [Double]
    let fillStyle: FillStyle
    let viewModel: GridShapeViewModel<XAxisDistance, YAxisValues<UnitType>>
    let filter: Filter

    init(xValues: [Double],
         yValues: [Double],
         fillStyle: FillStyle,
         filter: Filter,
         unit: UnitType,
         outUnit: UnitType) {
        self.xValues = xValues
        self.yValues = yValues
        self.fillStyle = fillStyle
        self.filter = filter
        self.viewModel = GridShapeViewModel(
            x: XAxisDistance(distance: xValues.max() ?? .zero, maxCount: 10),
            y: YAxisValues(
                min: yValues.min() ?? .zero,
                max: yValues.max() ?? .zero,
                maxCount: 5,
                unit: unit,
                outUnit: outUnit
            ),
            gridSize: CGSize(width: 64, height: 18), // TODO: Dynamic grid size
            position: [.leading, .bottom]
        )
    }

    @State private var scale = MountainShape<Filter>.AnimatableData(1.0, 0.0)

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                ZStack {
                    MountainShape(values: self.yValues, scale: self.scale, filter: self.filter, isClosed: true)
                        .fill(self.fillStyle)
                        .onAppear { self.scale = MountainShape<Filter>.AnimatableData(1.0, 1.0) }
                        .padding(.bottom, self.viewModel.gridSize.height)
                        .padding(.leading, self.viewModel.gridSize.width)
                    Image(uiImage: self.viewModel.xAxisImage(in: geometry.size)!)
                        .foregroundColor(.secondary)
                    Image(uiImage: self.viewModel.yAxisImage(in: geometry.size)!)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}
