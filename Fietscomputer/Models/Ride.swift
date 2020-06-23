//
//  Ride.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 18/06/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import CoreData
import CoreLocation

extension Ride: Identifiable {

    public override func awakeFromInsert() {
        super.awakeFromInsert()
        id = UUID()
        createdAt = Date()
        updatedAt = Date()
    }

    static var sortDescriptors: [NSSortDescriptor] {
        [NSSortDescriptor(keyPath: \Ride.updatedAt, ascending: false)]
    }

    @discardableResult
    static func create(name: String, context: NSManagedObjectContext) -> Ride {
        Ride(context: context).apply {
            $0.name = name
        }
    }

    func asRideSummary() -> RideService.Summary {
        RideService.Summary(
            duration: summary?.duration ?? 0,
            distance: summary?.distance ?? 0,
            avgSpeed: summary?.avgSpeed ?? 0,
            maxSpeed: summary?.maxSpeed ?? 0,
            elevationGain: summary?.elevationGain ?? 0
        )
    }

    func locations() -> [CLLocationCoordinate2D] {
        track?.locations() ?? []
    }

    func mapCenter() -> CLLocationCoordinate2D {
        locations().middle() ?? CLLocationCoordinate2D(latitude: 51.94, longitude: 4.49)
    }
}
