//
//  TrackerMapView.swift
//  Velik
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
        Coordinator(style: viewModel.style)
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        if viewModel.isTracking == false && viewModel.isLocationReady {
            viewModel.isTracking = true
            view.userTrackingMode = .followWithHeading
        }
        switch viewModel.rideState {
        case .running, .paused:
            view.addOverlay(viewModel.polyline)
        case .stopped:
            view.removeOverlays(view.overlays)
        default:
            ()
        }
    }

    class Coordinator: NSObject, MKMapViewDelegate {

        let style: MapViewModel.Style

        init(style: MapViewModel.Style) {
            self.style = style
        }

        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            guard overlay is MKPolyline else {
                return MKOverlayRenderer()
            }
            return MKPolylineRenderer(overlay: overlay).apply {
                $0.strokeColor = style.strokeColor
                $0.lineWidth = style.lineWidth
            }
        }
    }
}
