//
//  Power.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 20/06/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import Foundation

struct Power {

    static let tireValues = [0.005, 0.004, 0.012]
    static let aeroValues = [0.388, 0.445, 0.420, 0.300, 0.233, 0.200]

    enum Defaults {
        static let elevation = Measurement(value: 0, unit: UnitLength.meters)
        static let headWind = Measurement(value: 0, unit: UnitSpeed.metersPerSecond)
        static let temperature = Measurement(value: 20, unit: UnitTemperature.celsius)
        static let weight = Measurement(value: 80, unit: UnitMass.kilograms)
    }

    static func power(avgSpeed: Measurement<UnitSpeed>,
                      elevation: Measurement<UnitLength> = Defaults.elevation,
                      weight: Measurement<UnitMass> = Defaults.weight,
                      headWind: Measurement<UnitSpeed> = Defaults.headWind,
                      temperature: Measurement<UnitTemperature> = Defaults.temperature) -> Measurement<UnitPower> {

        let tire = tireValues[0]
        let aero = aeroValues[0]
        let temp = temperature.converted(to: .celsius).value
        let currentElevation = elevation.converted(to: .meters).value
        let airDensity = (1.293 - 0.00426 * temp) * exp(currentElevation / 7000)
        let airResistance = 0.5 * aero * airDensity
        let weightNewton = weight.converted(to: .kilograms).value * 9.8
        let rollingResistance = weightNewton * tire
        let speed = avgSpeed.converted(to: .metersPerSecond).value
        let totalSpeed = speed + headWind.converted(to: .metersPerSecond).value
        let air = totalSpeed > 0 ? airResistance : -airResistance
        let power = (speed * rollingResistance + speed * totalSpeed * totalSpeed * air) / 0.95

        return Measurement(value: power, unit: .watts)
    }
}
