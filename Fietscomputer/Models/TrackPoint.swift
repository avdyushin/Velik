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
        TrackPoint(context: context).apply {
            $0.elevation = location.altitude
            $0.latitude = location.coordinate.latitude
            $0.longitude = location.coordinate.longitude
            $0.speed = location.speed
            $0.timestamp = location.timestamp
        }
    }
}
