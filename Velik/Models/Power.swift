//
//  Power.swift
//  Velik
//
//  Created by Grigory Avdyushin on 20/06/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import Foundation

struct Parameters {

    enum Defaults {
        static let altitude = Measurement(value: 0, unit: UnitLength.meters)
        static let temperature = Measurement(value: 20, unit: UnitTemperature.celsius)
        static let wind = Measurement(value: 0, unit: UnitSpeed.metersPerSecond)
        static let mass = Measurement(value: 80, unit: UnitMass.kilograms)
    }

    let avgSpeed: Measurement<UnitSpeed>
    let altitude: Measurement<UnitLength>
    let temperature: Measurement<UnitTemperature>
    let wind: Measurement<UnitSpeed>
    let weight: Measurement<UnitMass>
    let segmentDistance: Measurement<UnitLength>?
    let segmentElevation: Measurement<UnitLength>?

    init(avgSpeed: Measurement<UnitSpeed>,
         altitude: Measurement<UnitLength> = Defaults.altitude,
         temperature: Measurement<UnitTemperature> = Defaults.temperature,
         wind: Measurement<UnitSpeed> = Defaults.wind,
         weight: Measurement<UnitMass> = Defaults.mass,
         segmentDistance: Measurement<UnitLength>? = nil,
         segmentElevation: Measurement<UnitLength>? = nil) {
        self.avgSpeed = avgSpeed
        self.altitude = altitude
        self.temperature = temperature
        self.wind = wind
        self.weight = weight
        self.segmentDistance = segmentDistance
        self.segmentElevation = segmentElevation
    }
}

struct Power {

    // swiftlint:disable identifier_name
    static func power(parameters: Parameters) -> Measurement<UnitPower> {

        // Input
        let v = parameters.avgSpeed.converted(to: .metersPerSecond).value
        let h = parameters.altitude.converted(to: .meters).value
        let t = parameters.temperature.converted(to: .kelvin).value
        let m = parameters.weight.converted(to: .kilograms).value
        let w = parameters.wind.converted(to: .metersPerSecond).value
        let H = parameters.segmentElevation?.converted(to: .meters).value ?? 0
        let L = parameters.segmentDistance?.converted(to: .meters).value ?? 1

        // Constants
        let p = 101325.0 // zero pressure
        let M = 0.0289654 // molar mass of dry air
        let R = 8.31447 // ideal gas constant
        let Hn = 10400.0 // height reference
        let g = 9.8 // gravitational acceleration
        let loss = 0.02 // 2%
        let CdA = [0.388, 0.445, 0.420, 0.300, 0.233, 0.200] // Cd * A
        let Crr = [0.005, 0.004, 0.012] // rolling resistance

        // Calculations
        let rho = p * M / (R * t) * exp(-h / Hn)
        let V = pow(v + w, 2)
        let theta = asin(H / L)

        let Fg = m * g * sin(theta)
        let Fr = m * g * Crr[0] * cos(theta)
        let Fd = 0.5 * CdA[0] * rho * V

        let power = (Fg + Fr + Fd) * v * (1 + loss)

        return Measurement(value: power, unit: .watts)
    }
    // swiftlint:enable identifier_name
}
