//
//  FietscomputerTests.swift
//  FietscomputerTests
//
//  Created by Grigory Avdyushin on 30/04/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import XCTest
@testable import Fietscomputer

class FietscomputerTests: XCTestCase {

    struct Location {
        let speed: Double
    }

    func testSequences() {
        let locations = [Location(speed: 10), Location(speed: 20), Location(speed: 40)]
        XCTAssertEqual(40.0, locations.max(by: \.speed)?.speed)
        XCTAssertEqual(23.33333, locations.average(by: \.speed), accuracy: 1e-3)
    }

    func testPower() {
        let power = Power.power(
            avgSpeed: Measurement(value: 20, unit: UnitSpeed.kilometersPerHour),
            elevation: Measurement(value: 7, unit: UnitLength.meters),
            weight: Measurement(value: 70, unit: UnitMass.kilograms)
        )
        XCTAssertEqual(62.39, power.value, accuracy: 0.1)
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
