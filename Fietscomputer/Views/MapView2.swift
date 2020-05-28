//
//  MapView2.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 18/05/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import MapKit
import SwiftUI

struct MapView2: UIViewRepresentable {

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
                if let speed /* m/s */ = mapView.userLocation.location?.speed {
                    // 14 m/s ~ 50 km/h
                    switch CGFloat(speed) {
                    case 0..<5:
                        renderer.strokeColor = UIColor(
                            red: CGFloat(speed / 5), green: 1, blue: 0, alpha: 1
                        )
                    case 5...10:
                        renderer.strokeColor = UIColor(
                            red: 1, green: 1 - CGFloat((speed - 5) / 5), blue: 0, alpha: 1
                        )
                    default:
                        renderer.strokeColor = UIColor(
                            red: 1, green: 0, blue: 0, alpha: 1
                        )
                    }
                } else {
                    renderer.strokeColor = .systemGreen
                }
                renderer.lineWidth = 10
                return renderer
            } else {
                return MKOverlayRenderer()
            }
        }
    }
}
