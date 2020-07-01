//
//  Track.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 19/06/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import CoreData
import class CoreLocation.CLLocation
import struct CoreLocation.CLLocationCoordinate2D

@objc(Track)
public final class Track: NSManagedObject {

    @NSManaged public var createdAt: Date
    @NSManaged public var id: UUID
    @NSManaged public var name: String?
    @NSManaged public var updatedAt: Date
    @NSManaged public var points: Set<TrackPoint>?
    @NSManaged public var ride: Ride?

    @objc(addPointsObject:)
    @NSManaged public func addToPoints(_ value: TrackPoint)

    @objc(removePointsObject:)
    @NSManaged public func removeFromPoints(_ value: TrackPoint)

    @objc(addPoints:)
    @NSManaged public func addToPoints(_ values: Set<TrackPoint>)

    @objc(removePoints:)
    @NSManaged public func removeFromPoints(_ values: Set<TrackPoint>)

    @nonobjc class func fetchRequest() -> NSFetchRequest<Track> {
        NSFetchRequest<Track>(entityName: String(describing: self))
    }

    public override func awakeFromInsert() {
        super.awakeFromInsert()
        id = UUID()
        createdAt = Date()
        updatedAt = Date()
    }

    @discardableResult
    static func create(name: String, context: NSManagedObjectContext) -> Track {
        Track(context: context).apply {
            $0.name = name
        }
    }

    func addTrackPoint(with location: CLLocation, context: NSManagedObjectContext) {
        addToPoints(
            TrackPoint.create(with: location, context: context)
        )
    }

    func locations() -> [CLLocation] {
        points?
            .sorted(by: \.timestamp)
            .map(CLLocation.init) ?? []
    }
}

extension Track: Encodable {

    enum CodingKeys: String, CodingKey {
        case id
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

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        var metadata = container.nestedContainer(keyedBy: MetadataCodingKeys.self, forKey: .metadata)
        try metadata.encode(createdAt, forKey: .time)
        var trackContainer = container.nestedContainer(keyedBy: TrackCodingKeys.self, forKey: .track)
        try trackContainer.encodeIfPresent(name, forKey: .name)
        var pointsContainer = trackContainer.nestedContainer(keyedBy: PointsCodingKeys.self, forKey: .segment)
        try points?.forEach {
            try pointsContainer.encode($0, forKey: .point)
        }
    }
}
