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

extension Track {

    public override func awakeFromInsert() {
        super.awakeFromInsert()
        id = UUID()
        createdAt = Date()
        updatedAt = Date()
    }

    var trackPoints: [TrackPoint] { points?.toTypedArray() ?? [] }

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

    func locations() -> [CLLocationCoordinate2D] {
        trackPoints
            .sorted(by: \.timestamp)
            .map(CLLocationCoordinate2D.init)
    }
}
