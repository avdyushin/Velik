//
//  MapViewModel.swift
//  Fietscomputer
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

        locationService.started
            .print("location started here")
            .assign(to: \.isLocationStarted, on: self)
            .store(in: &cancellables)

        rideService.state
            .print("ride started here")
            .assign(to: \.rideState, on: self)
            .store(in: &cancellables)

        rideService.track
            .removeDuplicates()
            .assign(to: \.polyline, on: self)
            .store(in: &cancellables)
    }
}
