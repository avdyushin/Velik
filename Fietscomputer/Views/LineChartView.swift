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
    }

    @State private var scale = MountainShape.AnimatableData(1.0, 0.0)

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                ZStack {
                    MountainShape(values: self.yValues, scale: self.scale, isClosed: true)
                        .fill(self.fillStyle)
                        .onAppear { self.scale = MountainShape.AnimatableData(1.0, 1.0) }
                        .padding(.bottom, self.viewModel.gridSize.height)
                        .padding(.leading, self.viewModel.gridSize.width)
                    GridShape(viewModel: self.viewModel)
                        .stroke(Color.red, lineWidth: 3)
                        //.stroke(Color.gray.opacity(0.3))
                }
                HStack {
                    ForEach(0..<self.viewModel.xValues.count - 1, id: \.self) { index in
                        Group {
                            Text("\(DistanceUtils.string(for: self.viewModel.xValues[index]))")
                            if index != self.viewModel.xValues.count - 2 {
                                Spacer()
                            }
                        }
                    }
                }
                .frame(width: self.viewModel.maxX(in: geometry.size))
                .background(Color.yellow)
                .padding(.leading, self.viewModel.gridSize.width)
            }
        }
    }
}
