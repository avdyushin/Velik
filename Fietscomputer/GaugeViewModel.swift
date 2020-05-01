//
//  GaugeViewModel.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 01/05/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import Combine

class ViewModel {
    @Injected var rideService: RideService
    @Injected var locationService: LocationService

    var cancellables = Set<AnyCancellable>()
}

class GaugeViewModel: ViewModel, ObservableObject {

    @Published var value = ""
    @Published var units = ""
    @Published var fontSize = 24
}
