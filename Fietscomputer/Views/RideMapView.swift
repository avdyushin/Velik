//
//  RideMapView.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 09/07/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import MapKit
import SwiftUI

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

            let annotations = viewModel.locations.distanceLocations().map(makeAnnotation)
            uiView.addAnnotations(annotations)
        }
    }

    func makeAnnotation(_ pair: LocationWithDistance) -> MKAnnotation {
        MKPointAnnotation().apply {
            $0.coordinate = pair.location.coordinate
            $0.title = "\(pair.distance)"
        }
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if overlay is MKPolyline {
                let renderer = MKPolylineRenderer(overlay: overlay)
                renderer.strokeColor = .systemGreen
                renderer.lineWidth = 8
                return renderer
            } else {
                return MKOverlayRenderer()
            }
        }
    }
}
