//
//  Filter.swift
//  Velik
//
//  Created by Grigory Avdyushin on 13/07/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import Foundation

protocol Filter {
    var value: Double { get set }

    func update(_ value: Double) -> Double
}

class LowPassFilter: Filter {

    var value: Double = 0
    let factor: Double

    init(initialValue: Double? = .zero, factor: Double) {
        self.value = initialValue ?? .zero
        self.factor = factor
    }

    func update(_ newValue: Double) -> Double {
        value = factor * newValue + value * (1.0 - factor)
        return value
    }
}
