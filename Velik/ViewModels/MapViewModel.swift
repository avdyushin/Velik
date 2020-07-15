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

    @Published var polyline = MKPolyline()
    @Published var isLocationStarted = false
    @Published var rideState = RideService.State.idle
    @Published var isTracking = false

    override init() {
        super.init()

        locationService.state
            .map {
                switch $0 {
                case .idle: return false
                case .monitoring: return true
                }
            }
            .print("location started here")
            .assign(to: \.isLocationStarted, on: self)
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
