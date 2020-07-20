//
//  RideMapView.swift
//  Velik
//
//  Created by Grigory Avdyushin on 09/07/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import MapKit
import SwiftUI

class DistanceAnnotation: MKPointAnnotation {

    let distance: Measurement<UnitLength>
    var glyphText: String { DistanceUtils.string(for: distance) }

    init(_ distance: Measurement<UnitLength>, coordinate: CLLocationCoordinate2D) {
        self.distance = distance
        super.init()
        self.coordinate = coordinate
    }
}

struct RideMapView: UIViewRepresentable {

    struct Style {
        let startColor: UIColor
        let stopColor: UIColor
        let lineWidth: CGFloat

        static let blue = Style(
            startColor: .flatEmeraldColor,
            stopColor: .flatMidnightBlueColor,
            lineWidth: 4
        )
    }

    typealias UIViewType = MKMapView

    let viewModel: RideDetailsViewModel
    let style = Style.blue

    func makeUIView(context: Context) -> MKMapView {
        let view = MKMapView()
        view.showsUserLocation = false
        view.userTrackingMode = .none
        view.delegate = context.coordinator
        return view
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(style: style)
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.setRegion(viewModel.mapRegion, animated: true)

        if !viewModel.coordinates.isEmpty {
            uiView.addOverlay(
                MKPolyline(coordinates: viewModel.coordinates, count: viewModel.coordinates.count)
            )

            let annotations = viewModel.locations
                .distanceLocations()
                .map(makeAnnotation)

            uiView.addAnnotations(annotations)
        }
    }

    func makeAnnotation(_ pair: LocationWithDistance) -> MKAnnotation {
        DistanceAnnotation(pair.distance, coordinate: pair.location.coordinate)
    }

    class Coordinator: NSObject, MKMapViewDelegate {

        let style: Style

        init(style: Style) {
            self.style = style
        }

        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            guard overlay is MKPolyline else {
                return MKOverlayRenderer()
            }
            return GradientPolylineRenderer(overlay: overlay).apply {
                $0.colors = [style.startColor, style.stopColor]
                $0.strokeColor = .systemGreen
                $0.lineWidth = style.lineWidth
            }
        }

        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard let annotation = annotation as? DistanceAnnotation else {
                return nil
            }

            return MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: nil).apply {
                $0.markerTintColor = .systemGreen
                $0.glyphText = annotation.glyphText
            }
        }
    }
}
