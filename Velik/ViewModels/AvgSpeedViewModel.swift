//
//  AvgSpeedViewModel.swift
//  Velik
//
//  Created by Grigory Avdyushin on 14/07/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import Foundation

class AvgSpeedViewModel: GaugeViewModel {

    override init() {
        super.init()

        fontSize = 100
        title = Strings.avg_speed.uppercased()
        rideService.avgSpeed
            .sink { value in // m/s
                let formatted = RideViewModel.speed(value)
                self.value = formatted.value
                self.units = formatted.units.uppercased()
            }
            .store(in: &cancellable)
    }
}
