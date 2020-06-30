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

    @State private var scale = MountainShape.AnimatableData(1.0, 0.0)

    var body: some View {
        HStack {
            MountainShape(values: self.values, scale: self.scale, isClosed: true)
                    .fill(self.fillStyle)
                    .onAppear { self.scale = AnimatablePair(1.0, 1.0) }
        }
    }
}
