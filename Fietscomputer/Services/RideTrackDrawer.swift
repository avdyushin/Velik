//
//  RideTrackDrawer.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 23/06/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import MapKit

struct RideTrackDrawer: MapSnapshotProcessor {

    let startColor = UIColor.fdAndroidGreen
    let stopColor = UIColor.flatGreenSeaColor
    let latitudinalMeters: CLLocationDistance = 200
    let longitudinalMeters: CLLocationDistance = 200

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
        context.setLineCap(.round)

        let points = locations.map { snapshot.point(for: $0) }
        let path = CGMutablePath()
        path.addLines(between: points)

        context.draw { context in
            context.addPath(path)
            context.replacePathWithStrokedPath()
            context.clip()

            let colours = [startColor.cgColor, stopColor.cgColor] as CFArray
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            var gradient = CGGradient(colorsSpace: colorSpace, colors: colours, locations: nil)

            context.drawLinearGradient(
                gradient!,
                start: CGPoint(x: 0, y: 0),
                end: CGPoint(x: snapshot.image.size.width, y: snapshot.image.size.height),
                options: []
            )
            gradient = nil
        }

        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
