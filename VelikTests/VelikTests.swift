//
//  VelikTests.swift
//  VelikTests
//
//  Created by Grigory Avdyushin on 30/04/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import XCTest
@testable import Velik

class VelikTests: XCTestCase {

    struct Location {
        let speed: Double
        let lat: Double
        let lon: Double
    }

    func testSequences() {
        let locations = [
            Location(speed: 10, lat: 0, lon: 0),
            Location(speed: 20, lat: 0, lon: 0),
            Location(speed: 40, lat: 0, lon: 0)
        ]
        XCTAssertEqual(40.0, locations.max(by: \.speed)?.speed)
        XCTAssertEqual(10.0, locations.min(by: \.speed)?.speed)
        XCTAssertEqual(23.33333, locations.average(by: \.speed), accuracy: 1e-3)
    }

    func testPowerLow() {
        let power = Power.power(parameters:
            Parameters(
                avgSpeed: Measurement(value: 18, unit: UnitSpeed.kilometersPerHour),
                altitude: Measurement(value: 7, unit: UnitLength.meters),
                weight: Measurement(value: 70, unit: UnitMass.kilograms)
            )
        )
        XCTAssertEqual(47.25, power.value, accuracy: 0.1)
    }

    func testPowerHigh() {
        let power = Power.power(parameters:
            Parameters(
                avgSpeed: Measurement(value: 23, unit: UnitSpeed.kilometersPerHour),
                altitude: Measurement(value: 7, unit: UnitLength.meters),
                weight: Measurement(value: 70, unit: UnitMass.kilograms)
            )
        )
        XCTAssertEqual(84.44, power.value, accuracy: 0.1)
    }

    func testKj() {
        let energy = Energy.energy(
            power: Measurement(value: 68, unit: UnitPower.watts),
            duration: Measurement(value: 74, unit: UnitDuration.minutes)
        )
        XCTAssertEqual(301.92, energy.value, accuracy: 0.1)
    }

    func testKcal() {
        let energy = Energy.energy(
            power: Measurement(value: 68, unit: UnitPower.watts),
            duration: Measurement(value: 74, unit: UnitDuration.minutes)
        ).converted(to: .kilocalories)
        XCTAssertEqual(72.16, energy.value, accuracy: 0.1)
    }

    func testWeightLoss() {
        let loss = Weight.loss(energy: Measurement(value: 3500, unit: .kilocalories))
        XCTAssertEqual(0.45, loss.value, accuracy: 0.1)
    }
}
