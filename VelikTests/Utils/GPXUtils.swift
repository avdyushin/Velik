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
        case waypoints = "Track_WayPoints"
        case withoutTime = "Track_Route"
        case segment = "Track_Strava"
        case short = "Track_210620"
        case long = "Track_150720"
        case longS = "Track_150720_S"
    }

    static func read(file: GPXFiles) -> String {
        try! String(contentsOf:
            Bundle(for: Self.self)
                .url(forResource: file.rawValue, withExtension: "gpx")!
        )
    }
}
