//
//  MKMapSnapshotter+Extension.swift
//  Velik
//
//  Created by Grigory Avdyushin on 19/06/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import MapKit

extension MKMapSnapshotter.Options {
    convenience init(region: MKCoordinateRegion, size: CGSize) {
        self.init()
        self.region = region
        self.size = size
    }
}

extension MKMapSnapshotter {
    // swiftlint:disable:next identifier_name
    static func Publisher(region: MKCoordinateRegion,
                          size: CGSize = CGSize(width: 1200, height: 800),
                          processor: MapSnapshotProcessor) -> MKMapSnapshotterPublisher {
        let options = MKMapSnapshotter.Options(region: region, size: size)
        let snapshotter = MKMapSnapshotter(options: options)
        return MKMapSnapshotterPublisher(snapshotter: snapshotter, processor: processor)
    }
}
