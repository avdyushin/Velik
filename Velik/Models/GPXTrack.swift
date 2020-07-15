//
//  GPXTrack.swift
//  Velik
//
//  Created by Grigory Avdyushin on 02/07/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import Foundation
import CoreLocation

struct GPXTrack {
    let id: UUID
    let name: String?
    let timestamp: Date
    let points: [GPXPoint]

    var locations: [CLLocation] { points.map(CLLocation.init) }
}

extension GPXTrack {
    init(track: Track) {
        self.id = track.id
        self.name = track.name
        self.timestamp = track.createdAt
        self.points = track.points?.map(GPXPoint.init) ?? []
    }
}

extension GPXTrack: Encodable, XMLNodeEncodable {

    enum CodingKeys: String, CodingKey {
        case creator
        case metadata
        case track = "trk"
        case waypoint = "wpt"
    }

    enum MetadataCodingKeys: CodingKey {
        case name
        case time
    }

    enum TrackCodingKeys: String, CodingKey {
        case name
        case segment = "trkseg"
    }

    enum PointsCodingKeys: String, CodingKey {
        case point = "trkpt"
    }

    static func nodeEncoding(forKey key: CodingKey) -> XMLEncoder.NodeEncodingStrategy {
        switch key {
        case CodingKeys.creator: return .attribute
        default: return .element
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode("MyCoolApp 1.0", forKey: .creator)
        var metadata = container.nestedContainer(keyedBy: MetadataCodingKeys.self, forKey: .metadata)
        try metadata.encode(timestamp, forKey: .time)
        var trackContainer = container.nestedContainer(keyedBy: TrackCodingKeys.self, forKey: .track)
        try trackContainer.encodeIfPresent(name, forKey: .name)
        var pointsContainer = trackContainer.nestedContainer(keyedBy: PointsCodingKeys.self, forKey: .segment)
        try points
            .sorted { pointA, pointB in
                switch (pointA.timestamp, pointB.timestamp) {
                case (.some(let timestampA), .some(let timestampB)):
                    return timestampA < timestampB
                default:
                    return false
                }
            }
            .forEach {
                try pointsContainer.encode($0, forKey: .point)
            }
    }
}

extension GPXTrack: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID()
        let metadata = try container.nestedContainer(keyedBy: MetadataCodingKeys.self, forKey: .metadata)
        self.timestamp = try metadata.decode(Date.self, forKey: .time)
        if container.contains(.track) {
            let trackContainer = try container.nestedContainer(keyedBy: TrackCodingKeys.self, forKey: .track)
            self.name = try trackContainer.decodeIfPresent(String.self, forKey: .name)
            let segmentContainer = try trackContainer.nestedContainer(keyedBy: PointsCodingKeys.self, forKey: .segment)
            var pointsContainer = try segmentContainer.nestedUnkeyedContainer(forKey: .point)
            if var count = pointsContainer.count, count > 0 {
                var points = [GPXPoint]()
                while count > 0 {
                    defer { count -= 1 }
                    points.append(try pointsContainer.decode(GPXPoint.self))
                }
                self.points = points
            } else {
                self.points = []
            }
        } else {
            self.name = try metadata.decodeIfPresent(String.self, forKey: .name)
            var pointsContainer = try container.nestedUnkeyedContainer(forKey: .waypoint)
            if var count = pointsContainer.count, count > 0 {
                var points = [GPXPoint]()
                while count > 0 {
                    defer { count -= 1 }
                    points.append(try pointsContainer.decode(GPXPoint.self))
                }
                self.points = points
            } else {
                self.points = []
            }
        }
    }
}
