//
//  MKMapSnapshotter+Extension.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 19/06/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import MapKit

extension MKMapSnapshotter.Options {
    convenience init(region: MKCoordinateRegion) {
        self.init()
        self.region = region
    }
}

extension MKMapSnapshotter {
    // swiftlint:disable:next identifier_name
    static func Publisher(center: CLLocationCoordinate2D,
                          latitudinalMeters: CLLocationDistance,
                          longitudinalMeters: CLLocationDistance) -> MKMapSnapshotterPublisher {
        let options = MKMapSnapshotter.Options(
            region: MKCoordinateRegion(
                center: center,
                latitudinalMeters: latitudinalMeters,
                longitudinalMeters: longitudinalMeters
            )
        )
        options.size = CGSize(width: 1200, height: 800)
        let snapshotter = MKMapSnapshotter(options: options)
        return MKMapSnapshotterPublisher(snapshotter: snapshotter)
    }
}
