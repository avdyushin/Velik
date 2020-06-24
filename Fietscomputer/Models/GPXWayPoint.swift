//
//  GPXWayPoint.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 24/06/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import Foundation

struct GPXWayPoint: Codable {

    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
        case elevation = "ele"
        case timestamp = "time"
    }

    let latitude: Double
    let longitude: Double
    let elevation: Double
    let timestamp: Date
}
