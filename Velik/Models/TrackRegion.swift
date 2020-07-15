//
//  TrackRegion.swift
//  Velik
//
//  Created by Grigory Avdyushin on 07/07/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import MapKit
import CoreData

extension TrackRegion {

    @discardableResult
    static func create(region: MKCoordinateRegion, context: NSManagedObjectContext) -> TrackRegion {
        TrackRegion(context: context).apply {
            $0.latitudeCenter = region.center.latitude
            $0.longitudeCenter = region.center.longitude
            $0.latitudeDelta = region.span.latitudeDelta
            $0.longitudeDelta = region.span.longitudeDelta
        }
    }

    func asMKCoordinateRegion(scale: (latitude: Double, longitude: Double) = (1, 1)) -> MKCoordinateRegion {
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: latitudeCenter,
                longitude: longitudeCenter),
            span: MKCoordinateSpan(
                latitudeDelta: latitudeDelta * scale.latitude,
                longitudeDelta: longitudeDelta * scale.longitude)
        )
    }
}
