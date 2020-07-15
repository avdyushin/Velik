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

    typealias UIViewType = MKMapView

    let viewModel: RideDetailsViewModel

    func makeUIView(context: Context) -> MKMapView {
        let view = MKMapView()
        view.showsUserLocation = false
        view.userTrackingMode = .none
        view.delegate = context.coordinator
        return view
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
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
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if overlay is MKPolyline {
                let renderer = GradientPolylineRenderer(overlay: overlay)
                renderer.colors = [.fdBaraRed, .fdHollyhock]
                renderer.strokeColor = .systemGreen
                renderer.lineWidth = 8
                return renderer
            } else {
                return MKOverlayRenderer()
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
