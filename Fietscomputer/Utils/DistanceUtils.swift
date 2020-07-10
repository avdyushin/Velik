//
//  DistanceUtils.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 10/07/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import Foundation
import CoreLocation

enum DistanceUtils {

    static func step(for distance: CLLocationDistance) -> Measurement<UnitLength> {
        let meters = Measurement<UnitLength>(value: distance, unit: .meters)
        let step: Measurement<UnitLength>

        if meters.value / 1_000 > 1 {
            step = Measurement(value: 1, unit: .kilometers)
        } else if meters.value / 100 > 1 {
            step = Measurement(value: 100, unit: .meters)
        } else {
            step = Measurement(value: 10, unit: .meters)
        }
        return step
    }

    static var distanceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 0
        formatter.minimumFractionDigits = 0
        return formatter
    }()

    static func string(for distance: Measurement<UnitLength>) -> String {
        string(for: distance.value)
    }

    static func string(for distance: CLLocationDistance) -> String {
        Self.distanceFormatter.string(from: NSNumber(value: distance)) ?? ""
    }
}
