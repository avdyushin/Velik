//
//  TrackPoint.swift
//  Velik
//
//  Created by Grigory Avdyushin on 19/06/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import CoreData
import class CoreLocation.CLLocation
import struct CoreLocation.CLLocationSpeed
import struct CoreLocation.CLLocationDistance

@objc(TrackPoint)
public final class TrackPoint: NSManagedObject {

    @nonobjc class func fetchRequest() -> NSFetchRequest<TrackPoint> {
        NSFetchRequest<TrackPoint>(entityName: String(describing: self))
    }

    public override func awakeFromInsert() {
        super.awakeFromInsert()
        id = UUID()
    }

    @NSManaged public var elevation: Double
    @NSManaged public var id: UUID
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var name: String?
    @NSManaged public var speed: Double
    @NSManaged public var timestamp: Date
    @NSManaged public var track: Track?
}

extension TrackPoint {

    @discardableResult
    static func create(with location: CLLocation, context: NSManagedObjectContext) -> TrackPoint {
        TrackPoint(context: context).apply {
            $0.elevation = location.altitude
            $0.latitude = location.coordinate.latitude
            $0.longitude = location.coordinate.longitude
            $0.speed = max(0, location.speed)
            $0.timestamp = location.timestamp
        }
    }
}

extension TrackPoint: Encodable {

    enum CodingKeys: String, CodingKey {
        case id
        case elevation
        case latitude
        case longitude
        case name
        case speed
        case timestamp
    }

    enum CodingErrors: Error {
        case missingContext
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(elevation, forKey: .elevation)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
        try container.encodeIfPresent(name, forKey: .name)
        try container.encode(speed, forKey: .speed)
        try container.encode(timestamp, forKey: .timestamp)
    }
}
