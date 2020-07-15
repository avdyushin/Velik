//
//  Timer2.swift
//  Velik
//
//  Created by Grigory Avdyushin on 18/05/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import Combine
import Foundation

class Timer2 {

    let timer = Timer.TimerPublisher(interval: 1.0, runLoop: .main, mode: .default)
    private var cancellable = Set<AnyCancellable>()

    init() {
        timer
            .connect()
            .store(in: &cancellable)
    }

    deinit {
        cancellable.forEach { $0.cancel() }
    }
}
