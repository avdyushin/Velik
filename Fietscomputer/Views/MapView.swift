//
//  MapView.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 30/04/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import MapKit
import SwiftUI
import Combine

class MapViewModel: ViewModel, ObservableObject {

    @Published var polyline = MKPolyline()
    @Published var isLocationStarted = false
    @Published var isRideStarted = false
    @Published var isTracking = false

    override init() {
        super.init()

        locationService.started
            .print("location started here")
            .assign(to: \.isLocationStarted, on: self)
            .store(in: &cancellables)

        rideService.started
            .print("ride started here")
            .assign(to: \.isRideStarted, on: self)
            .store(in: &cancellables)

        rideService.track
            .removeDuplicates()
            .assign(to: \.polyline, on: self)
            .store(in: &cancellables)
    }
}

struct UserTrackingButton: UIViewRepresentable {

    typealias UIViewType = MKUserTrackingButton

    func makeUIView(context: Context) -> MKUserTrackingButton {
        MKUserTrackingButton(mapView: context.environment.mkMapView)
    }

    func updateUIView(_ view: MKUserTrackingButton, context: Context) { }
}

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
        debugPrint("update ui")
        if viewModel.isTracking == false && viewModel.isLocationStarted {
            debugPrint("start tracking")
            viewModel.isTracking = true
            view.userTrackingMode = .followWithHeading
        }
        if viewModel.isRideStarted {
            view.addOverlay(viewModel.polyline)
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

struct EnvironmentMKMapView: EnvironmentKey {
    typealias Value = MKMapView
    static var defaultValue = MKMapView()
}

extension EnvironmentValues {
    var mkMapView: MKMapView {
        get { self[EnvironmentMKMapView.self] }
        set { self[EnvironmentMKMapView.self] = newValue }
    }
}

struct MapView: View {

    @ObservedObject var viewModel: MapViewModel
    @Environment(\.mkMapView) var mkMapView: MKMapView

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            MapView2(viewModel: viewModel)
            ZStack {
                Rectangle().fill(Color(.systemBackground)).cornerRadius(4).shadow(radius: 2)
                UserTrackingButton().accentColor(Color.green).fixedSize()
            }.fixedSize().padding(EdgeInsets(top: 0, leading: 0, bottom: 32, trailing: 16))
        }
    }
}
