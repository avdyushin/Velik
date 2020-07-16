//
//  TrackPointTests.swift
//  VelikTests
//
//  Created by Grigory Avdyushin on 24/06/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import XCTest
import CoreData
import CoreLocation
import CoreDataStorage
@testable import Velik

class TrackPointTests: XCTestCase {

    var storage: CoreDataStorage!
    var parser: NanoXML!

    override func setUpWithError() throws {
        try super.setUpWithError()
        let container = try! NSPersistentContainer("Velik")
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

    func createXML(file: GPXUtils.GPXFiles) {
        parser = NanoXML(xmlString: GPXUtils.read(file: file))
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

    func testDecodeGPXTrack() throws {
        createXML(file: .segment)
        let xml = parser.root!
        let track = try GPXTrack(from: XMLDecoder(xml))
        let waypoint = track.points.first!
        XCTAssertEqual(51.943208, waypoint.latitude, accuracy: 1e-4)
        XCTAssertEqual(4.484162, waypoint.longitude, accuracy: 1e-4)
        if let elevation = waypoint.elevation {
            XCTAssertEqual(-0.5, elevation, accuracy: 0.1)
        }
        XCTAssertEqual(4441, track.points.count)
    }

    func testDecodeExportedTrack() throws {
        let bundle = Bundle(for: type(of: self))
        let url = bundle.url(forResource: "Track_Velik", withExtension: "gpx")!
        let track: GPXTrack = try XMLDecoder.decode(try String(contentsOf: url))
        let waypoint = track.points.first!
        XCTAssertEqual(51.943208, waypoint.latitude, accuracy: 1e-4)
        XCTAssertEqual(4.484162, waypoint.longitude, accuracy: 1e-4)
        if let elevation = waypoint.elevation {
            XCTAssertEqual(-0.5, elevation, accuracy: 0.1)
        }
        XCTAssertEqual(4441, track.points.count)
    }

    func testGPXImporter() throws {
        let bundle = Bundle(for: type(of: self))
        let url = bundle.url(forResource: "Track_Strava", withExtension: "gpx")!
        let gpxImporter = GPXImporter()

        let expectation = self.expectation(description: "Imported")
        let cancellable = gpxImporter.availableGPX.sink { track in
            let waypoint = track.points.first!
            XCTAssertEqual(51.943208, waypoint.latitude, accuracy: 1e-4)
            XCTAssertEqual(4.484162, waypoint.longitude, accuracy: 1e-4)
            if let elevation = waypoint.elevation {
                XCTAssertEqual(-0.5, elevation, accuracy: 0.1)
            }
            XCTAssertEqual(4441, track.points.count)
            expectation.fulfill()
        }
        try gpxImporter.import(url: url)
        self.wait(for: [expectation], timeout: 1)
        XCTAssertNotNil(cancellable)
    }

    func testDistanceCalculation() throws {
        createXML(file: .segment)
        let xml = parser.root!
        let track = try GPXTrack(from: XMLDecoder(xml))
        var current = track.locations.first!
        var distance = 0.0
        track.locations.dropFirst().forEach {
            distance += current.distance(from: $0)
            current = $0
        }
        XCTAssertEqual(25152.3893, distance, accuracy: 1)
        let total = track.locations.accumulateDistance().max()!
        XCTAssertEqual(25152.3893, total, accuracy: 0.1)
    }

    func testDistanceCalculation2() throws {
        createXML(file: .withoutTime)
        let track = parser.root
        let decoder = XMLDecoder(track!, name: "wpt")
        let locations = try [GPXPoint](from: decoder).map(CLLocation.init)
        var current = locations.first!
        var distance = 0.0
        locations.dropFirst().forEach {
            distance += current.distance(from: $0)
            current = $0
        }
        XCTAssertEqual(34020.7127, distance, accuracy: 0.001)
        let total = locations.accumulateDistance().max()!
        XCTAssertEqual(34020.7127, total, accuracy: 0.1)
    }

//    func testCoreDataDecoder() {
//        createXML(name: "Ride2")
//        let decoder = XMLDecoder(first!)
//        decoder.userInfo[CodingUserInfoKey.context!] = storage.mainContext
//        XCTAssertNoThrow(try TrackPoint(from: decoder))
//    }
}
