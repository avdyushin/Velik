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

class MapViewModel: ObservableObject {

    @Published var lines: [MKPolyline] = []
    @Published var isServiceRunning = false
    @Published var isTracking = false

    private let service: LocationService
    private var cancellebles = Set<AnyCancellable>()

    init(service: LocationService) {
        self.service = service

        self.service.track
            .sink {
                self.lines.append($0)
            }
            .store(in: &cancellebles)

        self.service.started
            .assign(to: \.isServiceRunning, on: self)
            .store(in: &cancellebles)
    }
}

struct UserTrackingButton: UIViewRepresentable {

    typealias UIViewType = MKUserTrackingButton

    func makeUIView(context: Context) -> MKUserTrackingButton {
        MKUserTrackingButton(mapView: context.environment.mkMapView)
    }

    func updateUIView(_ view: MKUserTrackingButton, context: Context) {

    }
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
        view.tintColor = UIColor.green
        view.delegate = context.coordinator
        return view
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        if viewModel.isTracking == false && viewModel.isServiceRunning {
            debugPrint("start tracking")
            viewModel.isTracking = true
            view.userTrackingMode = .followWithHeading
        }
        if let last = viewModel.lines.last {
            view.addOverlay(last)
        }
    }

    class Coordinator: NSObject, MKMapViewDelegate {

        private let parent: MapView2
        private var cancellables = Set<AnyCancellable>()

        init(_ parent: MapView2) {
            self.parent = parent
        }

        func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        }

        func mapViewWillStartLocatingUser(_ mapView: MKMapView) {
        }

        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        }

//        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
//            if let polyline = overlay as? MKPolyline {
//                let renderer = MKPolylineRenderer(polyline: polyline)
//                polyline.title = "foo"
//                renderer.strokeColor = .black
//                renderer.lineWidth = 3
//                return renderer
//            } else {
//                return MKOverlayRenderer()
//            }
//        }
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
                Rectangle().fill(Color.white).cornerRadius(4).shadow(radius: 2)
                UserTrackingButton().accentColor(Color.green).fixedSize()//.padding(4)
            }.fixedSize().padding(EdgeInsets(top: 0, leading: 0, bottom: 32, trailing: 16))
        }
    }
}
