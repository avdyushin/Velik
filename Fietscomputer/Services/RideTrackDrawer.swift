//
//  RideTrackDrawer.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 23/06/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import MapKit

struct RideTrackStyle {
    let startColor: UIColor
    let stopColor: UIColor
    let lineWidth: CGFloat
    let drawMarkers: Bool

    static let green = RideTrackStyle(
        startColor: .fdAndroidGreen,
        stopColor: .flatGreenSeaColor,
        lineWidth: 10,
        drawMarkers: false
    )

    static let greenWithMarkers = RideTrackStyle(
        startColor: .fdAndroidGreen,
        stopColor: .flatGreenSeaColor,
        lineWidth: 10,
        drawMarkers: true
    )
}

struct RideTrackDrawer: MapSnapshotProcessor {

    private let style: RideTrackStyle
    private let locations: () -> [CLLocation]

    init(style: RideTrackStyle, _ locations: @escaping () -> [CLLocation]) {
        self.style = style
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

        context.setLineWidth(style.lineWidth)
        context.setLineCap(.round)
        context.setLineJoin(.round)

        // Track path
        let points = locations.map { snapshot.point(for: $0.coordinate) }
        let path = CGMutablePath()
        path.addLines(between: points)

        // Path stroke with gradient
        context.draw { context in
            context.addPath(path)
            context.replacePathWithStrokedPath()
            context.clip()

            let colours = [style.startColor.cgColor, style.stopColor.cgColor] as CFArray
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

        // Markers
        if style.drawMarkers {
            context.draw { _ in
                // UIImage(named: "marker")?.draw(at: points.first!.applying(.init(translationX: -8, y: -16)))
                UIImage(named: "finish")?.draw(at: points.last!.applying(.init(translationX: -8, y: -16)))

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

        return UIGraphicsGetImageFromCurrentImageContext()
    }

    private func drawDistanceMarker(_ distance: Int, at atPoint: CGPoint, in context: CGContext) {
        let popup = UIImage(named: "popup")!
        let point = atPoint.applying(.init(translationX: -popup.size.width / 2, y: -popup.size.height))
        popup.draw(at: point)

        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .body), size: 6)
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
