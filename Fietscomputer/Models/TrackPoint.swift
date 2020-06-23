//
//  TrackPoint.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 19/06/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import CoreData
import class CoreLocation.CLLocation

extension TrackPoint {

    public override func awakeFromInsert() {
        super.awakeFromInsert()
        id = UUID()
    }

    @discardableResult
    static func create(with location: CLLocation, context: NSManagedObjectContext) -> TrackPoint {
        let trackPoint = self.init(context: context)
        trackPoint.longitude = location.coordinate.longitude
        trackPoint.latitude = location.coordinate.latitude
        trackPoint.speed = location.speed
        trackPoint.elevation = location.altitude
        trackPoint.timestamp = location.timestamp
        return trackPoint
    }
}
