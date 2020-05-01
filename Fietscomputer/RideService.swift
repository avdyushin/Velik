//
//  RideService.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 01/05/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import Combine
import Foundation

class Timer2 {

    let timer = Timer.TimerPublisher(interval: 1.0, runLoop: .main, mode: .default)
    private var cancellables = Set<AnyCancellable>()

    init() {
        timer
            .connect()
            .store(in: &cancellables)
    }

    deinit {
        cancellables.forEach { $0.cancel() }
    }
}

class RideService: Service {

    var startDate = Date()
    var stopDate: Date?
    var timer = Timer2()

    private let elapsedTimePublisher = CurrentValueSubject<TimeInterval, Never>(0)
    private(set) var elapsed: AnyPublisher<TimeInterval, Never>

    private let startedPublisher = PassthroughSubject<Bool, Never>()
    var started: AnyPublisher<Bool, Never>

    private var cancellebles = Set<AnyCancellable>()

    init() {
        self.elapsed = elapsedTimePublisher.eraseToAnyPublisher()
        self.started = startedPublisher.eraseToAnyPublisher()
    }

    func start() {
        startDate = Date()
        startedPublisher.send(true)
        timer.timer.map { [startDate] currentDate in
            currentDate.timeIntervalSince1970 - startDate.timeIntervalSince1970
        }.sink { [elapsedTimePublisher] elapsed in
            elapsedTimePublisher.send(elapsed)
        }.store(in: &cancellebles)
    }

    func stop() {
        stopDate = Date()
        startedPublisher.send(false)
    }
}
