//
//  DurationViewModel.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 01/05/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import SwiftUI
import Combine

extension Formatters {

    static var elaspedFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = [.pad]
        return formatter
    }()
}

class DurationViewModel: GaugeViewModel {

    override init() {
        super.init()

        rideService.elapsed
            .sink { value in
                self.value = Formatters.elaspedFormatter.string(from: value)!
            }
            .store(in: &cancellables)
    }
}
