//
//  RideService.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 01/05/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import MapKit
import Combine
import Injected
import Foundation
import CoreLocation

class RideService: Service {

    enum State {
        case idle
        case running
        case paused(Bool)
        case stopped
    }

    @Injected private var locationService: LocationService
    @Injected private var storageService: StorageService

    let shouldAutostart = false

    private var locations = [CLLocation]()
    private var totalDistance: CLLocationDistance = 0

    private let trackPublisher = PassthroughSubject<MKPolyline, Never>()
    private(set) var track: AnyPublisher<MKPolyline, Never>

    private let distancePublisher = CurrentValueSubject<CLLocationDistance, Never>(0)
    private(set) var distance: AnyPublisher<CLLocationDistance, Never>

    private var startDate: TimeInterval = 0
    private var pausedDate: TimeInterval = 0
    private var stopDate: TimeInterval = 0
    private var timer = Timer2()
    private var timerCancellable: AnyCancellable?

    private let elapsedTimePublisher = CurrentValueSubject<TimeInterval, Never>(0)
    private(set) var elapsed: AnyPublisher<TimeInterval, Never>

    private let statePublisher = CurrentValueSubject<State, Never>(.idle)
    private(set) var state: AnyPublisher<State, Never>

    private var cancellables = Set<AnyCancellable>()

    init() {
        self.elapsed = elapsedTimePublisher.eraseToAnyPublisher()
        self.state = statePublisher.eraseToAnyPublisher()
        self.track = trackPublisher.eraseToAnyPublisher()
        self.distance = distancePublisher.eraseToAnyPublisher()
        reset()
    }

    func reset() {
        startDate = 0
        pausedDate = 0
        stopDate = 0
        totalDistance = 0
    }

    func start() {
        startDate = Date.timeIntervalSinceReferenceDate
        statePublisher.send(.running)

        locationService.location.sink { location in
            self.locations.append(location)
            if self.locations.count >= 2 {
                let locationA = self.locations[self.locations.count - 2]
                let locationB = self.locations[self.locations.count - 1]
                var coordinates = [locationA, locationB].map { $0.coordinate }
                self.trackPublisher.send(MKPolyline(coordinates: &coordinates, count: 2))
                let delta = locationA.distance(from: locationB)
                self.totalDistance += delta
                self.distancePublisher.send(self.totalDistance)
            }
        }.store(in: &cancellables)

        run()
    }

    func restart() {
        reset()
        start()
    }

    func pause(automatic: Bool = false) {
        pausedDate = Date.timeIntervalSinceReferenceDate
        timerCancellable?.cancel()
        statePublisher.send(.paused(automatic))
    }

    func resume() {
        startDate += (Date.timeIntervalSinceReferenceDate - pausedDate)
        statePublisher.send(.running)
        run()
    }

    func stop() {
        stopDate = Date.timeIntervalSinceReferenceDate
        statePublisher.send(.stopped)
        timerCancellable?.cancel()
        elapsedTimePublisher.send(0)
        distancePublisher.send(0)
        storeRide()
    }

    func toggle() {
        switch statePublisher.value {
        case .idle:
            start()
        case .paused:
            resume()
        case .running:
            pause()
        case .stopped:
            restart()
        }
    }

    private func run() {
        timer = Timer2()
        timerCancellable = timer.timer.map { [startDate] _ in
            Date.timeIntervalSinceReferenceDate - startDate
        }.sink { [elapsedTimePublisher] elapsed in
            elapsedTimePublisher.send(elapsed)
        }//.store(in: &cancellables)
    }

    private func storeRide() {
        storageService.createNewRide(name: "Ride \(Int.random(in: 1...10))")
    }
}
