//
//  GPXUtils.swift
//  VelikTests
//
//  Created by Grigory Avdyushin on 09/07/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import Foundation

class GPXUtils {

    enum GPXFiles: String {
        case waypoints = "WayPoints"
        case withoutTime = "NoTime"
        case segment = "TrackSegment"
    }

    static func readFile(file: GPXFiles) -> String {
        try! String(contentsOf:
            Bundle(for: Self.self)
                .url(forResource: file.rawValue, withExtension: "gpx")!
        )
    }
}
