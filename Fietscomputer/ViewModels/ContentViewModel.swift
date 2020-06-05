//
//  ContentViewModel.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 18/05/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import SwiftUI

class ContentViewModel: ViewModel, ObservableObject {

    @ObservedObject var mapViewModel: MapViewModel
    @ObservedObject var speedViewModel: SpeedViewModel
    @ObservedObject var durationViewModel: DurationViewModel
    @ObservedObject var distanceViewModel: DistanceViewModel
    @ObservedObject var goButtonViewModel: GoButtonViewModel
    @ObservedObject var stopButtonViewModel: StopButtonViewModel

    var numberOfPages = 4

    init(mapViewModel: MapViewModel,
         speedViewModel: SpeedViewModel,
         durationViewModel: DurationViewModel,
         distanceViewModel: DistanceViewModel) {
        self.mapViewModel = mapViewModel
        self.speedViewModel = speedViewModel
        self.durationViewModel = durationViewModel
        self.distanceViewModel = distanceViewModel
        self.goButtonViewModel = GoButtonViewModel()
        self.stopButtonViewModel = StopButtonViewModel()
        super.init()
    }

    func startPauseRide() {
        rideService.toggle()
    }

    func stopRide() {
        rideService.stop()
    }
}
