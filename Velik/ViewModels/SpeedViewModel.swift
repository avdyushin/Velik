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
        let last = locationService.speed.debounce(for: .seconds(10), scheduler: RunLoop.main)
        locationService.speed
            .merge(with: last)
            .subscribe(on: RunLoop.main)
            .removeDuplicates()
            .sink { value in // m/s
                debugPrint("received", value)
                let formatted = RideViewModel.speed(value)
                self.value = formatted.value
                self.units = formatted.units.uppercased()
            }
            .store(in: &cancellable)
    }
}
