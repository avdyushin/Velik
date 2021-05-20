//
//  RideTrackDrawer.swift
//  Velik
//
//  Created by Grigory Avdyushin on 23/06/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import MapKit

protocol LocationDrawable {
    func draw(context: CGContext, size: CGSize, locations: [CLLocation], snapshot: MKMapSnapshotter.Snapshot)
}

struct RideTrackDrawer: MapSnapshotProcessor {

    private var drawables = [LocationDrawable]()
    private let locations: () -> [CLLocation]

    @resultBuilder public struct DrawableBuilder {
        public static func buildBlock(_ drawable: LocationDrawable) -> LocationDrawable { drawable }
        public static func buildBlock(_ drawables: LocationDrawable...) -> [LocationDrawable] { drawables }
    }

    init(_ locations: @escaping () -> [CLLocation], @DrawableBuilder _ drawables: () -> [LocationDrawable]) {
        self.drawables = drawables()
        self.locations = locations
    }

    init(_ locations: @escaping () -> [CLLocation], @DrawableBuilder _ drawable: () -> LocationDrawable) {
        self.drawables = [drawable()]
        self.locations = locations
    }

    func process(_ snapshot: MKMapSnapshotter.Snapshot?) -> UIImage? {
        dispatchPrecondition(condition: .notOnQueue(DispatchQueue.main))

        guard let snapshot = snapshot else { return nil }

        defer {
            UIGraphicsEndImageContext()
        }

        UIGraphicsBeginImageContextWithOptions(snapshot.image.size, false, UIScreen.main.scale)

        // Original image
        snapshot.image.draw(at: .zero)

        let locations = self.locations()

        guard let context = UIGraphicsGetCurrentContext(), locations.count > 1 else {
            return UIGraphicsGetImageFromCurrentImageContext()
        }

        drawables.forEach {
            $0.draw(context: context, size: snapshot.image.size, locations: locations, snapshot: snapshot)
        }

        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
