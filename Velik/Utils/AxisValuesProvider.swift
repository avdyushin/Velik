//
//  AxisValuesProvider.swift
//  Velik
//
//  Created by Grigory Avdyushin on 13/07/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import Foundation

protocol AxisValuesProvider {
    var values: [Double] { get }
}

struct XAxisDistance: AxisValuesProvider {

    let values: [Double]

    init(distance: Double, maxCount: Int) {
        precondition(maxCount > 0)

        values = DistanceUtils
            .distanceMarkers(for: distance, maxCount: maxCount)
            .map { $0.converted(to: .meters).value }
    }
}

struct YAxisValues: AxisValuesProvider {

    let values: [Double]

    init(min: Double, max: Double, maxCount: Int) {
        precondition(maxCount > 0)

        let step = (max - min) / Double(maxCount)
        values = Array(stride(from: min, to: max, by: step)) + [max]
    }
}
