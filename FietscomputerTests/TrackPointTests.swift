//
//  TrackPointTests.swift
//  FietscomputerTests
//
//  Created by Grigory Avdyushin on 24/06/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import XCTest
import CoreData
import CoreDataStorage
@testable import Fietscomputer

class TrackPointTests: XCTestCase {

    var storage: CoreDataStorage!
    var parser: NanoXML!

    override func setUpWithError() throws {
        try super.setUpWithError()
        let container = try! NSPersistentContainer("Fietscomputer")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false
        container.persistentStoreDescriptions = [description]
        storage = CoreDataStorage(container: container)

    }

    override func tearDownWithError() throws {
        storage = nil
        parser = nil
        try super.tearDownWithError()
    }

    func createXML(name: String) {
        let bundle = Bundle(for: type(of: self))
        let url = bundle.url(forResource: name, withExtension: "gpx")!
        let xml = try! String(contentsOf: url)
        parser = NanoXML(xmlString: xml)
    }

    func testDecodeSingleWaypoint() throws {
        createXML(name: "Ride2")
        let first = parser.rootNode()?.children.first { $0.name == "wpt" }
        let decoder = XMLDecoder(first!)
        let wpt = try GPXWayPoint(from: decoder)
        XCTAssertEqual(51.943208, wpt.latitude, accuracy: 1e-4)
        XCTAssertEqual(4.484162, wpt.longitude, accuracy: 1e-4)
        if let ele = wpt.elevation {
            XCTAssertEqual(-0.5, ele, accuracy: 0.1)
        }
        debugPrint(wpt)
    }

    func testDecodeSingleMinimumWaypoint() throws {
        createXML(name: "Ride1")
        let first = parser.rootNode()?.children.first { $0.name == "wpt" }
        let decoder = XMLDecoder(first!)
        let wpt = try GPXWayPoint(from: decoder)
        XCTAssertEqual(51.94334, wpt.latitude, accuracy: 1e-4)
        XCTAssertEqual(4.48391, wpt.longitude, accuracy: 1e-4)
        if let ele = wpt.elevation {
            XCTAssertEqual(-0.5, ele, accuracy: 0.1)
        }
        debugPrint(wpt)
    }

    func testWaypointContainer() throws {
        createXML(name: "Ride2")
        let first = parser.rootNode()
        let decoder = XMLDecoder(first!) { $0.name == "wpt" }
        let waypoints = try [GPXWayPoint](from: decoder)
        let wpt = waypoints.first!
        XCTAssertEqual(51.943208, wpt.latitude, accuracy: 1e-4)
        XCTAssertEqual(4.484162, wpt.longitude, accuracy: 1e-4)
        if let ele = wpt.elevation {
            XCTAssertEqual(-0.5, ele, accuracy: 0.1)
        }
        XCTAssertEqual(4441, waypoints.count)
    }

    func testCoreDataDecoder() {
//        createXML(name: "Ride2")
//        let decoder = XMLDecoder(first!)
//        decoder.userInfo[CodingUserInfoKey.context!] = storage.mainContext
//        XCTAssertNoThrow(try TrackPoint(from: decoder))
    }
}
