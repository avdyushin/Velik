//
//  DistanceUtils.swift
//  Velik
//
//  Created by Grigory Avdyushin on 10/07/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import Foundation
import CoreLocation

enum DistanceUtils {

    static func distanceMarkers(for distance: CLLocationDistance, maxCount: Int) -> [Measurement<UnitLength>] {
        let step = DistanceUtils.step(for: distance, maxCount: maxCount - 1 /* exclude zero */)
        let total = Measurement<UnitLength>(value: distance, unit: .meters).converted(to: step.unit)
        var values = Array(stride(from: 0, to: total.value, by: step.value))
        guard let last = values.last else {
            return []
        }
        if total.value != last {
            values += [total.value]
        }
        return values.map {
            Measurement<UnitLength>(value: $0, unit: step.unit)
        }
    }

    static func step(for distance: CLLocationDistance, maxCount: Int? = nil) -> Measurement<UnitLength> {
        let meters = Measurement<UnitLength>(value: distance, unit: .meters)
        var step: Measurement<UnitLength>

        if meters.value / Settings.shared.distanceStepInMeters > 1 {
            step = Measurement(value: 1, unit: Settings.shared.distanceUnit)
        } else if meters.value / 100 > 1 {
            step = Measurement(value: 100, unit: Settings.shared.smallDistanceUnit)
        } else {
            step = Measurement(value: 10, unit: Settings.shared.smallDistanceUnit)
        }

        if let maxCount = maxCount {
            var stepsCount = Int(meters.value / step.converted(to: .meters).value)
            var newStep = step
            var multiply = 1.0
            while stepsCount > maxCount {
                newStep.value = (5 * step.value * multiply)
                stepsCount = Int(meters.value / newStep.converted(to: .meters).value)
                multiply += 1
            }
            return newStep
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
