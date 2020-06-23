//
//  RideTrackDrawer.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 23/06/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import MapKit

struct RideTrackDrawer: MapSnapshotProcessor {

    var latitudinalMeters: CLLocationDistance = 200
    var longitudinalMeters: CLLocationDistance = 200

    private var locations: [CLLocationCoordinate2D]

    init(_ locations: [CLLocationCoordinate2D]) {
        self.locations = locations
    }

    func process(_ snapshot: MKMapSnapshotter.Snapshot?) -> UIImage? {
        guard let snapshot = snapshot else { return nil }
        defer {
            UIGraphicsEndImageContext()
        }

        UIGraphicsBeginImageContextWithOptions(snapshot.image.size, false, UIScreen.main.scale)

        // Original image
        snapshot.image.draw(at: .zero)

        guard let context = UIGraphicsGetCurrentContext(), locations.count > 1 else {
            return UIGraphicsGetImageFromCurrentImageContext()
        }

        context.setLineWidth(20)
        context.setStrokeColor(UIColor.blue.cgColor)

        let points = locations.map { snapshot.point(for: $0) }
        let path = CGMutablePath()
        path.addLines(between: points)
        context.addPath(path)
        context.strokePath()

        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
