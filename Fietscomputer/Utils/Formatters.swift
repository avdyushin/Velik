//
//  Formatters.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 18/05/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import Foundation

struct Formatters {
    static var speedMeasurement: MeasurementFormatter = {
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .short
        formatter.unitOptions = .providedUnit
        formatter.numberFormatter.maximumFractionDigits = 1
        formatter.numberFormatter.minimumFractionDigits = 1
        return formatter
    }()

    static var speedValue: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        formatter.minimumFractionDigits = 1
        return formatter
    }()

    static func formatted<U: Unit>(from measurement: Measurement<U>) -> (value: String, units: String) {
        let value = Formatters.speedValue.string(from: NSNumber(value: measurement.value))
        let units = Formatters.speedMeasurement.string(from: measurement.unit)
        return (value ?? "0.0", units)
    }
}
