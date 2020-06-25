//
//  GPX.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 25/06/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import CoreLocation

struct GPX {

    enum Errors: Error {
        case unsupportedFileFormat
    }

    let name: String?
    let points: [GPXPoint]

    var locations: [CLLocation] { points.map(CLLocation.init) }

    init(contentsOf url: URL) throws {

        let xml = try String(contentsOf: url)
        let parser = NanoXML(xmlString: xml)

        guard let root = parser.root else {
            throw Errors.unsupportedFileFormat
        }

        if let segment = root.find(path: "trk/trkseg") {
            points = try [GPXPoint](from: XMLDecoder(segment, name: "trkpt"))
            name = root.find(path: "trk/name")?.value
        } else {
            points = try [GPXPoint](from: XMLDecoder(root, name: "wpt"))
            name = root["name"]?.value
        }
    }
}
