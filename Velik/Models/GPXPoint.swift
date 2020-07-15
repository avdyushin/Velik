//
//  GPXPoint.swift
//  Velik
//
//  Created by Grigory Avdyushin on 24/06/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import Foundation

struct GPXPoint: Codable, XMLNodeEncodable {

    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
        case elevation = "ele"
        case speed
        case timestamp = "time"
    }

    static func nodeEncoding(forKey key: CodingKey) -> XMLEncoder.NodeEncodingStrategy {
        switch key {
        case CodingKeys.latitude, CodingKeys.longitude: return .attribute
        default: return .element
        }
    }

    let latitude: Double
    let longitude: Double
    let elevation: Double?
    let speed: Double?
    let timestamp: Date?
}

extension GPXPoint {
    init(trackPoint: TrackPoint) {
        self.latitude = trackPoint.latitude
        self.longitude = trackPoint.longitude
        self.elevation = trackPoint.elevation
        self.speed = trackPoint.speed
        self.timestamp = trackPoint.timestamp
    }
}
