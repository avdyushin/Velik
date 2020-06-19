//
//  Track.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 19/06/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import CoreData
import class CoreLocation.CLLocation

extension Track {

    public override func awakeFromInsert() {
        super.awakeFromInsert()
        id = UUID()
        createdAt = Date()
        updatedAt = Date()
    }

    @discardableResult
    static func create(name: String, context: NSManagedObjectContext) -> Track {
        let track = self.init(context: context)
        track.name = name
        return track
    }

    func addTrackPoint(with location: CLLocation, context: NSManagedObjectContext) {
        self.addToPoints(
            TrackPoint.create(with: location, context: context)
        )
    }
}
