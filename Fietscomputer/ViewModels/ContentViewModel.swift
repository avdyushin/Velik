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
    @ObservedObject var buttonViewModel: ActionButtonViewModel

    var numberOfPages = 4

    init(mapViewModel: MapViewModel,
         speedViewModel: SpeedViewModel,
         durationViewModel: DurationViewModel,
         distanceViewModel: DistanceViewModel) {
        self.mapViewModel = mapViewModel
        self.speedViewModel = speedViewModel
        self.durationViewModel = durationViewModel
        self.distanceViewModel = distanceViewModel
        self.buttonViewModel = ActionButtonViewModel()
        super.init()
    }

    func startPauseRide() {
        rideService.toggle()
    }

    func stopRide() {
        rideService.stop()
    }
}
