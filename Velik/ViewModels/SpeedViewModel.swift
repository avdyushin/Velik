//
//  SpeedViewModel.swift
//  Velik
//
//  Created by Grigory Avdyushin on 18/05/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import Foundation

class SpeedViewModel: GaugeViewModel {

    override init() {
        super.init()

        fontSize = 100
        title = Strings.current_speed.uppercased()
        locationService.speed
            .sink { value in // m/s
                let formatted = RideViewModel.speed(value)
                self.value = formatted.value
                self.units = formatted.units.uppercased()
            }
            .store(in: &cancellable)
    }
}
