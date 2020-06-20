//
//  Energy.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 20/06/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import Foundation

struct Energy {

    static func energy(power: Measurement<UnitPower>, duration: Measurement<UnitDuration>) -> Measurement<UnitEnergy> {
        let watts = power.converted(to: .watts)
        let seconds = duration.converted(to: .seconds)
        let kilojoules = watts.value / 1000 * seconds
        return Measurement(value: kilojoules.value, unit: UnitEnergy.kilojoules)
    }
}
