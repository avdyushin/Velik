//
//  AxisValuesProvider.swift
//  Velik
//
//  Created by Grigory Avdyushin on 13/07/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import Foundation

protocol AxisValuesProvider {
    associatedtype UnitType: Unit

    var values: [Double] { get }
    var markers: [Measurement<UnitType>] { get }
}

struct XAxisDistance: AxisValuesProvider {

    let values: [Double]
    let markers: [Measurement<UnitLength>]

    init(distance: Double, maxCount: Int) {
        precondition(maxCount > 0)

        markers = DistanceUtils.distanceMarkers(for: distance, maxCount: maxCount)
        values = markers.map { $0.converted(to: .meters).value }
    }
}

struct YAxisValues<UnitType: Unit>: AxisValuesProvider {

    let values: [Double]
    var markers: [Measurement<UnitType>]

    init(min: Double, max: Double, maxCount: Int, unit: UnitType) {
        precondition(maxCount > 0)

        let step = (max - min) / Double(maxCount)
        values = Array(stride(from: min, to: max, by: step)) + [max]
        markers = values.map { Measurement(value: $0, unit: unit) }
    }
}
