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

    enum GPXFiles: String {
        case waypoints = "WayPoints"
        case minimum = "NoTime"
        case segment = "TrackSegment"
    }

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

    func createXML(file: GPXFiles) {
        let bundle = Bundle(for: type(of: self))
        let url = bundle.url(forResource: file.rawValue, withExtension: "gpx")!
        let xml = try! String(contentsOf: url)
        parser = NanoXML(xmlString: xml)
    }

    func testDecodeNameWaypoint() throws {
        createXML(file: .waypoints)
        let name = parser.root?["name"]?.value
        XCTAssertEqual("Afternoon Ride", name)
    }

    func testDecodeNameSegment() throws {
        createXML(file: .segment)
        let name = parser.root?.find(path: "trk/name")?.value
        XCTAssertEqual("Afternoon Ride", name)
    }

    func testDecodeSingleWaypoint() throws {
        createXML(file: .waypoints)
        let first = parser.root?["wpt"]
        let decoder = XMLDecoder(first!)
        let waypoint = try GPXPoint(from: decoder)
        XCTAssertEqual(51.943208, waypoint.latitude, accuracy: 1e-4)
        XCTAssertEqual(4.484162, waypoint.longitude, accuracy: 1e-4)
        if let elevation = waypoint.elevation {
            XCTAssertEqual(-0.5, elevation, accuracy: 0.1)
        }
    }

    func testDecodeSingleMinimumWaypoint() throws {
        createXML(file: .minimum)
        let first = parser.root?["wpt"]
        let decoder = XMLDecoder(first!)
        let waypoint = try GPXPoint(from: decoder)
        XCTAssertEqual(51.94334, waypoint.latitude, accuracy: 1e-4)
        XCTAssertEqual(4.48391, waypoint.longitude, accuracy: 1e-4)
        if let elevation = waypoint.elevation {
            XCTAssertEqual(-0.5, elevation, accuracy: 0.1)
        }
    }

    func testWaypointContainer() throws {
        createXML(file: .waypoints)
        let first = parser.root
        let decoder = XMLDecoder(first!, name: "wpt")
        let waypoints = try [GPXPoint](from: decoder)
        let waypoint = waypoints.first!
        XCTAssertEqual(51.943208, waypoint.latitude, accuracy: 1e-4)
        XCTAssertEqual(4.484162, waypoint.longitude, accuracy: 1e-4)
        if let elevation = waypoint.elevation {
            XCTAssertEqual(-0.5, elevation, accuracy: 0.1)
        }
        XCTAssertEqual(4441, waypoints.count)
    }

    func testDecodeTrackSegment() throws {
        createXML(file: .segment)
        let track = parser.root?.find(path: "trk/trkseg/trkpt")
        let decoder = XMLDecoder(track!)
        let waypoint = try GPXPoint(from: decoder)
        XCTAssertEqual(51.943208, waypoint.latitude, accuracy: 1e-4)
        XCTAssertEqual(4.484162, waypoint.longitude, accuracy: 1e-4)
        if let elevation = waypoint.elevation {
            XCTAssertEqual(-0.5, elevation, accuracy: 0.1)
        }
    }

    func testDecodeSegmentContainer() throws {
        createXML(file: .segment)
        let track = parser.root?.find(path: "trk/trkseg")
        let decoder = XMLDecoder(track!, name: "trkpt")
        let waypoints = try [GPXPoint](from: decoder)
        let waypoint = waypoints.first!
        XCTAssertEqual(51.943208, waypoint.latitude, accuracy: 1e-4)
        XCTAssertEqual(4.484162, waypoint.longitude, accuracy: 1e-4)
        if let elevation = waypoint.elevation {
            XCTAssertEqual(-0.5, elevation, accuracy: 0.1)
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
