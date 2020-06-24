//
//  GPXImporter.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 24/06/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import Foundation

protocol DataImporter {
    func `import`(url: URL) throws
}

struct GPXImporter: DataImporter {

    enum Errors: Error {
        case invalidXML
    }

    func `import`(url: URL) throws {
        let xml = try String(contentsOf: url)
        let parser = NanoXML(xmlString: xml)

        guard let root = parser.rootNode() else {
            throw Errors.invalidXML
        }

        let decoder = XMLDecoder(root) { $0.name == "wpt" }
        let waypoints = try [GPXWayPoint](from: decoder)

        debugPrint("Got \(waypoints.count)")
    }
}
