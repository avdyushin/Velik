//
//  TrackDrawer.swift
//  Velik
//
//  Created by Grigory Avdyushin on 08/07/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import MapKit

struct TrackDrawer: LocationDrawable {

    struct Style {
        let startColor: UIColor
        let stopColor: UIColor
        let lineWidth: CGFloat

        static let green = Style(
            startColor: .fdAndroidGreen,
            stopColor: .flatGreenSeaColor,
            lineWidth: 10
        )

        static let blue = Style(
            startColor: .flatEmeraldColor,
            stopColor: .flatMidnightBlueColor,
            lineWidth: 10
        )
    }

    let style: Style
    let pathDrawer = GradientPathDrawer()

    func draw(context: CGContext, size: CGSize, locations: [CLLocation], snapshot: MKMapSnapshotter.Snapshot) {
        context.draw { context in
            context.setLineWidth(style.lineWidth)
            context.setLineCap(.round)
            context.setLineJoin(.round)

            // Track path
            let points = locations.map { snapshot.point(for: $0.coordinate) }
            let path = CGMutablePath()
            path.addLines(between: points)
            pathDrawer.draw(context: context, size: size, path: path, colors: [style.startColor, style.stopColor])
        }
    }
}
