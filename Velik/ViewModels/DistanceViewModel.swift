//
//  DistanceView.swift
//  Velik
//
//  Created by Grigory Avdyushin on 01/05/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import SwiftUI
import Combine

class DistanceViewModel: GaugeViewModel {

    override init() {
        super.init()

        rideService.distance
            .map { RideViewModel.distance($0) }
            .assign(to: \.value, on: self)
            .store(in: &cancellable)
    }
}
