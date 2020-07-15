//
//  DistanceTests.swift
//  VelikTests
//
//  Created by Grigory Avdyushin on 11/07/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import XCTest
@testable import Velik

class DistanceTests: XCTestCase {

    func testMeters() {
        let distance = Measurement<UnitLength>(value: 750, unit: .meters)
        let markers = DistanceUtils.distanceMarkers(for: distance.value, maxCount: 5).map { $0.value }
        XCTAssertEqual([0, 500, 750], markers)
    }

    func testMetersMultiply() {
        let distance = Measurement<UnitLength>(value: 400, unit: .meters)
        let markers = DistanceUtils.distanceMarkers(for: distance.value, maxCount: 5).map { $0.value }
        XCTAssertEqual([0, 100, 200, 300, 400], markers)
    }

    func testKilometers() {
        let distance = Measurement<UnitLength>(value: 15123, unit: .meters)
        let markers = DistanceUtils.distanceMarkers(for: distance.value, maxCount: 5).map { $0.value }
        XCTAssertEqual([0, 5, 10, 15, 15.123], markers)
    }

    func testKilometersMultiply() {
        let distance = Measurement<UnitLength>(value: 40000, unit: .meters)
        let markers = DistanceUtils.distanceMarkers(for: distance.value, maxCount: 5).map { $0.value }
        XCTAssertEqual([0, 10, 20, 30, 40], markers)
    }

    func testKilometersMultiply2() {
        let distance = Measurement<UnitLength>(value: 40000, unit: .meters)
        let markers = DistanceUtils.distanceMarkers(for: distance.value, maxCount: 3).map { $0.value }
        XCTAssertEqual([0, 15, 30, 40], markers)
    }
}
