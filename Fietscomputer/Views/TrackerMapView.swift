//
//  TrackerMapView.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 18/05/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import MapKit
import SwiftUI

struct TrackerMapView: UIViewRepresentable {

    typealias UIViewType = MKMapView

    @ObservedObject private var viewModel: MapViewModel

    init(viewModel: MapViewModel) {
        self.viewModel = viewModel
    }

    func makeUIView(context: Context) -> MKMapView {
        let view = context.environment.mkMapView
        view.showsUserLocation = true
        view.showsCompass = true
        view.mapType = .standard
        view.isZoomEnabled = true
        view.userTrackingMode = .none
        view.tintColor = UIColor.systemGreen
        view.delegate = context.coordinator
        return view
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        if viewModel.isTracking == false && viewModel.isLocationStarted {
            viewModel.isTracking = true
            view.userTrackingMode = .followWithHeading
        }
        switch viewModel.rideState {
        case .running, .paused:
            view.addOverlay(viewModel.polyline)
        default:
            ()
        }
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if overlay is MKPolyline {
                let renderer = MKPolylineRenderer(overlay: overlay)
                renderer.strokeColor = .systemGreen
                renderer.lineWidth = 10
                return renderer
            } else {
                return MKOverlayRenderer()
            }
        }
    }
}
