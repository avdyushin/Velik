//
//  DistanceView.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 01/05/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import SwiftUI
import Combine

extension Formatters {

    static var distanceFormatter: MeasurementFormatter = {
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .medium
        formatter.unitOptions = [.providedUnit]
        formatter.numberFormatter.maximumFractionDigits = 1
        formatter.numberFormatter.minimumFractionDigits = 1
        return formatter
    }()
}

class DistanceViewModel: GaugeViewModel {

    override init() {
        super.init()

        locationService.distance
            .sink { value in
                let km = Measurement(value: value, unit: UnitLength.meters).converted(to: .kilometers)
                self.value = Formatters.distanceFormatter.string(from: km)
            }
            .store(in: &cancellables)
    }

}
