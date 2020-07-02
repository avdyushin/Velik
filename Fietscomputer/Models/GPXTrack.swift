//
//  GPXTrack.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 02/07/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import Foundation

struct GPXTrack {
    let id: UUID
    let name: String?
    let timestamp: Date
    let points: [GPXPoint]
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
    }

    enum MetadataCodingKeys: CodingKey {
        case time
    }

    enum TrackCodingKeys: String, CodingKey {
        case name
        case segment = "trkseg"
    }

    enum PointsCodingKeys: String, CodingKey {
        case point = "trkpt"
    }

    static func nodeEncoding(forKey key: CodingKey) -> XMLEncoder.NodeEncoding {
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
        try points.forEach {
            try pointsContainer.encode($0, forKey: .point)
        }
    }
}
