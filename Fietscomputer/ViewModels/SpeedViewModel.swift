//
//  SpeedViewModel.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 18/05/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import Foundation

class SpeedViewModel: GaugeViewModel {

    override init() {
        super.init()

        fontSize = 100
        locationService.speed
            .map { $0 < 0 ? 0 : $0 } // filter out negative values
            .sink { value in // m/s
                let mps = Measurement(value: value, unit: UnitSpeed.metersPerSecond)
                let kph = mps.converted(to: UnitSpeed.kilometersPerHour)
                let formatted = Formatters.formatted(from: kph)
                self.value = formatted.value
                self.units = formatted.units.uppercased()
        }
        .store(in: &cancellables)
    }
}