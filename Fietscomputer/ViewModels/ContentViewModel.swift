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

    @Published var buttonTitle = "Start"

    init(mapViewModel: MapViewModel, speedViewModel: SpeedViewModel, durationViewModel: DurationViewModel,
         distanceViewModel: DistanceViewModel) {
        self.mapViewModel = mapViewModel
        self.speedViewModel = speedViewModel
        self.durationViewModel = durationViewModel
        self.distanceViewModel = distanceViewModel

        super.init()

        rideService.state
            .map {
                switch $0 {
                case .idle, .stopped: return "Start"
                case .paused: return "Continue"
                case .running: return "Pause"
                }
        }
        .assign(to: \.buttonTitle, on: self)
        .store(in: &cancellables)
    }

    func startPauseRide() {
        rideService.toggle()
    }
}
