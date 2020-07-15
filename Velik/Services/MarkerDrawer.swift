//
//  MarkerDrawer.swift
//  Velik
//
//  Created by Grigory Avdyushin on 08/07/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import MapKit

struct MarkerDrawer: LocationDrawable {

    func draw(context: CGContext, size: CGSize, locations: [CLLocation], snapshot: MKMapSnapshotter.Snapshot) {
        context.draw { _ in

            let last = snapshot.point(for: locations.last!.coordinate)
            UIImage(named: "finish")?.draw(at: last.applying(.init(translationX: -8, y: -16)))

            locations.distanceLocations { location, distance in
                let point = snapshot.point(for: location.coordinate)
                drawDistanceMarker(distance, at: point, in: context)
            }
        }
    }

    private func drawDistanceMarker(_ distance: Measurement<UnitLength>, at atPoint: CGPoint, in context: CGContext) {
        let popup = UIImage(named: "place-marker")!
        let point = atPoint.applying(.init(translationX: -popup.size.width / 2, y: -popup.size.height))
        popup.draw(at: point)

        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .body), size: 8)
        ]
        let string = NSAttributedString(string: DistanceUtils.string(for: distance), attributes: attributes)
        let textSize = string.size()
        let center = point
            .applying(.init(
                translationX: (popup.size.width - textSize.width) / 2,
                y: (popup.size.height - textSize.height) / 2))
        string.draw(at: center)
    }
}
