//
//  LineChartView.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 27/06/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import SwiftUI
import CoreLocation

struct LineChartView<S: ShapeStyle>: View {

    let values: [Double]
    let fillStyle: S

    let yLabels = [0, 10, 20, 30]
    let xLabels = [10, 20, 30, 40, 50]

    @State private var scale = MountainShape.AnimatableData(1.0, 0.0)

    private let gridSize = CGSize(width: 32, height: 16)

    var body: some View {
        VStack {
            HStack {
                VStack {
                    ForEach(0..<yLabels.count, id: \.self) { index in
                        Group {
                            Spacer()
                            Text("\(self.yLabels[index])")
                            Spacer()
                        }
                    }
                }
                ZStack {
                    MountainShape(values: values, scale: scale, isClosed: true)
                        .fill(fillStyle)
                        .onAppear { self.scale = MountainShape.AnimatableData(1.0, 1.0) }
                        .padding(.bottom, gridSize.height)
                        .padding(.leading, gridSize.width)
                    GridShape(values: values, size: gridSize, position: [.leading, .bottom])
                        .stroke(Color.gray.opacity(0.3))
                }
            }
            HStack {
                ForEach(0..<xLabels.count, id: \.self) { index in
                    Group {
                        Spacer()
                        Text("\(self.xLabels[index])")
                        Spacer()
                    }
                }
            }
        }
    }
}
