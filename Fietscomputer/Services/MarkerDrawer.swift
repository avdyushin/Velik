//
//  MarkerDrawer.swift
//  Fietscomputer
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

            let total = locations.accumulateDistance().max() ?? 0
            let step: Double
            if total / 1000 > 1 {
                step = 1000
            } else if total / 100 > 1 {
                step = 100
            } else {
                step = 0
            }
            if step > 0 {
                var value = 0
                locations.accumulateDistance().enumerated().forEach { index, distance in
                    let location = locations[index]
                    if Int(distance / step) > value {
                        value += 1
                        let point = snapshot.point(for: location.coordinate)
                        drawDistanceMarker(value, at: point, in: context)
                    }
                }
            }
        }
    }

    private func drawDistanceMarker(_ distance: Int, at atPoint: CGPoint, in context: CGContext) {
        let popup = UIImage(named: "place-marker")!
        let point = atPoint.applying(.init(translationX: -popup.size.width / 2, y: -popup.size.height))
        popup.draw(at: point)

        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .body), size: 8)
        ]
        let string = NSAttributedString(string: "\(distance)", attributes: attributes)
        let textSize = string.size()
        let center = point
            .applying(.init(
                translationX: (popup.size.width - textSize.width) / 2,
                y: (popup.size.height - textSize.height) / 2))
        string.draw(at: center)
    }
}
