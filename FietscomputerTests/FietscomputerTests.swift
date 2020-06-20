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

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    struct Location {
        let speed: Double
    }

    func testSequences() throws {
        let locations = [Location(speed: 10), Location(speed: 20), Location(speed: 40)]
        XCTAssertEqual(40.0, locations.max(by: \.speed)?.speed)
        XCTAssertEqual(23.33333, locations.average(by: \.speed), accuracy: 1e-3)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
