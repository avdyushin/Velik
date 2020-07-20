//
//  MapViewModel.swift
//  Velik
//
//  Created by Grigory Avdyushin on 18/05/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import MapKit
import SwiftUI

class MapViewModel: ViewModel, ObservableObject {

    struct Style {
        let strokeColor = UIColor.systemGreen
        let lineWidth: CGFloat = 10
    }

    @Published var polyline = MKPolyline()
    @Published var isLocationReady = false
    @Published var rideState = RideService.State.idle
    @Published var isTracking = false

    let style = Style()

    override init() {
        super.init()

        locationService.state
            .map {
                switch $0 {
                case .ready: return true
                default: return false
                }
            }
            .print("location started here")
            .assign(to: \.isLocationReady, on: self)
            .store(in: &cancellable)

        rideService.state
            .print("ride started here")
            .assign(to: \.rideState, on: self)
            .store(in: &cancellable)

        rideService.track
            .removeDuplicates()
            .assign(to: \.polyline, on: self)
            .store(in: &cancellable)
    }
}
