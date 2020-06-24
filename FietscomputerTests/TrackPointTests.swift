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

        let bundle = Bundle(for: type(of: self))
        let url = bundle.url(forResource: "Ride2", withExtension: "gpx")!
        let xml = try! String(contentsOf: url)
        parser = NanoXML(xmlString: xml)
    }

    override func tearDownWithError() throws {
        storage = nil
        parser = nil
        try super.tearDownWithError()
    }

    func testDecodeSingleWaypoint() throws {
        let first = parser.rootNode()?.children.first { $0.name == "wpt" }
        let decoder = XMLDecoder(first!)
        let wpt = try GPXWayPoint(from: decoder)
        XCTAssertEqual(51.943208, wpt.latitude, accuracy: 1e-4)
        XCTAssertEqual(4.484162, wpt.longitude, accuracy: 1e-4)
        XCTAssertEqual(-0.5, wpt.elevation, accuracy: 0.1)
        debugPrint(wpt)
    }

    func testCoreDataDecoder() {
//        let decoder = XMLDecoder(first!)
//        decoder.userInfo[CodingUserInfoKey.context!] = storage.mainContext
//        XCTAssertNoThrow(try TrackPoint(from: decoder))
    }
}
