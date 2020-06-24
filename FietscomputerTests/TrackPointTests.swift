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
        try super.tearDownWithError()
    }

    func testXmlDecoder() throws {
        let bundle = Bundle(for: type(of: self))
        let url = bundle.url(forResource: "Ride2", withExtension: "gpx")!
        let xml = try! String(contentsOf: url)
        let parser = NanoXML(xmlString: xml)
        let decoder = XMLDecoder(parser.rootNode()!)
        decoder.userInfo[CodingUserInfoKey.context!] = storage.mainContext
        XCTAssertNoThrow(try TrackPoint(from: decoder))
    }
}
