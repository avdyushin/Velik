//
//  SpeedViewModel.swift
//  Velik
//
//  Created by Grigory Avdyushin on 18/05/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import Combine
import Foundation
import CoreLocation

class SpeedViewModel: GaugeViewModel {

    override init() {
        super.init()

        fontSize = 160
        title = Strings.current_speed.uppercased()

        locationService.speed.map { _ in .zero }.debounce(for: .seconds(10), scheduler: RunLoop.main)
            .merge(with: locationService.speed)
            .removeDuplicates()
            .sink { value in // m/s
                let formatted = RideViewModel.speed(value, unit: Settings.shared.speedUnit)
                self.value = formatted.value
                self.units = formatted.units.uppercased()
            }
            .store(in: &cancellable)
    }
}
