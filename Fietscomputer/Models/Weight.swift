//
//  Weight.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 20/06/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import Foundation

struct Weight {

    static func loss(energy: Measurement<UnitEnergy>) -> Measurement<UnitMass> {
        // 3,500 kcal ~ 0.45 kg of fat
        // 1 kcal = 0.000128571 kg
        let kcals = energy.converted(to: .kilocalories)
        return Measurement(value: 0.000128571 * kcals.value, unit: UnitMass.kilograms)
    }
}
