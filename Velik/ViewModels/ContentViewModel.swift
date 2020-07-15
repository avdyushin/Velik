//
//  ContentViewModel.swift
//  Velik
//
//  Created by Grigory Avdyushin on 18/05/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import SwiftUI
import SplitView

class ContentViewModel: ViewModel, ObservableObject {

    @ObservedObject var mapViewModel: MapViewModel
    @ObservedObject var speedViewModel: SpeedViewModel
    @ObservedObject var avgSpeedViewModel: AvgSpeedViewModel
    @ObservedObject var durationViewModel: DurationViewModel
    @ObservedObject var distanceViewModel: DistanceViewModel
    @ObservedObject var goButtonViewModel: GoButtonViewModel
    @ObservedObject var stopButtonViewModel: StopButtonViewModel
    @ObservedObject var notificationViewModel: NotificationViewModel
    @ObservedObject var sliderViewModel: SliderControlViewModel

    let numberOfPages = 2

    init(mapViewModel: MapViewModel,
         speedViewModel: SpeedViewModel,
         avgSpeedViewModel: AvgSpeedViewModel,
         durationViewModel: DurationViewModel,
         distanceViewModel: DistanceViewModel,
         notificationViewModel: NotificationViewModel,
         sliderViewModel: SliderControlViewModel) {
        self.mapViewModel = mapViewModel
        self.speedViewModel = speedViewModel
        self.avgSpeedViewModel = avgSpeedViewModel
        self.durationViewModel = durationViewModel
        self.distanceViewModel = distanceViewModel
        self.goButtonViewModel = GoButtonViewModel()
        self.stopButtonViewModel = StopButtonViewModel()
        self.notificationViewModel = notificationViewModel
        self.sliderViewModel = sliderViewModel
        super.init()
    }

    func startPauseRide() {
        rideService.toggle()
    }

    func stopRide() {
        rideService.stop()
    }
}
