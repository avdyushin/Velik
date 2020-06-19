//
//  RideViewModel.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 19/06/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import Foundation

class RideViewModel {

    var date: String

    var distance: String
    var duration: String
    var avgSpeed: String
    var maxSpeed: String

    let distanceLabel = "Distance"
    let durationLabel = "Duration"
    let avgSpeedLabel = "Avg. Speed"
    let maxSpeedLabel = "Max Speed"

    init(createdAt: Date?, summary: RideService.Summary) {
        date = Self.date(createdAt)
        distance = Self.distance(summary.distance)
        duration = Self.duration(summary.duration)
        let avgSpeedPair = Self.speed(summary.avgSpeed)
        avgSpeed = avgSpeedPair.value + " " + avgSpeedPair.units
        let maxSpeedPair = Self.speed(summary.maxSpeed)
        maxSpeed = maxSpeedPair.value + " " + maxSpeedPair.units
    }

    static func date(_ value: Date?) -> String {
        guard let value = value else { return "Unknown" }
        let date = Formatters.relativeDateFormatter.localizedString(fromTimeInterval: value.timeIntervalSinceNow)
        if value.timeIntervalSinceNow > -60*60*24 {
            return date
        } else {
            let time = Formatters.timeFormatter.string(from: value)
            return [date, "at", time].joined(separator: " ")
        }
    }

    static func distance(_ value: Double?) -> String {
        let kilometers = Measurement(value: value ?? 0, unit: UnitLength.meters).converted(to: .kilometers)
        return Formatters.distanceFormatter.string(from: kilometers)
    }

    static func duration(_ value: Double?) -> String {
        Formatters.elaspedFormatter.string(from: value ?? 0)!
    }

    static func speed(_ value: Double?) -> ValueUnitPair {
        let mps = Measurement(value: value ?? 0, unit: UnitSpeed.metersPerSecond)
        let kph = mps.converted(to: UnitSpeed.kilometersPerHour)
        return Formatters.formatted(from: kph)
    }
}
