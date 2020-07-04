//
//  DurationViewModel.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 01/05/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import SwiftUI
import Combine

class DurationViewModel: GaugeViewModel {

    override init() {
        super.init()

        rideService.elapsed
            .map { RideViewModel.duration($0) }
            .assign(to: \.value, on: self)
            .store(in: &cancellable)
    }
}
