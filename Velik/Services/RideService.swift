//
//  RideService.swift
//  Velik
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

    struct Summary {
        let duration: TimeInterval // s
        let distance: CLLocationDistance // m
        let avgSpeed: CLLocationSpeed // m/s
        let maxSpeed: CLLocationSpeed // ms
        let elevationGain: CLLocationDistance // m
        let avgPower: Double
        let energy: Double
        let weigthLoss: Double

        init(duration: Double, distance: CLLocationDistance,
             avgSpeed: CLLocationSpeed, maxSpeed: CLLocationSpeed,
             elevationGain: CLLocationDistance) {

            // Filer out negative values
            self.duration = max(.zero, duration)
            self.distance = max(.zero, distance)
            self.avgSpeed = max(.zero, avgSpeed)
            self.maxSpeed = max(.zero, maxSpeed)
            self.elevationGain = max(.zero, elevationGain)

            // Calculations
            let configuration = Parameters(avgSpeed: Measurement(value: avgSpeed, unit: .metersPerSecond))
            let power = Power.power(parameters: configuration)
            self.avgPower = power.value
            let energy = Energy.energy(power: power, duration: Measurement(value: duration, unit: .seconds))
            self.energy = energy.value
            self.weigthLoss = Weight.loss(energy: energy).value
        }

        static func empty() -> Self {
            .init(duration: 0, distance: 0, avgSpeed: 0, maxSpeed: 0, elevationGain: 0)
        }
    }

    @Injected private var locationService: LocationService
    @Injected private var storageService: StorageService

    let shouldAutostart = false

    private var locations = [CLLocation]()
    private var totalDistance: CLLocationDistance = 0
    private var duration: TimeInterval = 0
    private var elevationGain: CLLocationDistance = 0
    private var elevationGainProcessor: ElevationGainProcessor?

    private let trackPublisher = PassthroughSubject<MKPolyline, Never>()
    private(set) var track: AnyPublisher<MKPolyline, Never>

    private let distancePublisher = CurrentValueSubject<CLLocationDistance, Never>(0)
    private(set) var distance: AnyPublisher<CLLocationDistance, Never>

    private let avgSpeedPublisher = CurrentValueSubject<CLLocationSpeed, Never>(0)
    private(set) var avgSpeed: AnyPublisher<CLLocationSpeed, Never>

    private var startDate: TimeInterval = 0
    private var pausedDate: TimeInterval = 0
    private var stopDate: TimeInterval = 0
    private var timer = Timer2()
    private var timerCancellable: AnyCancellable?

    private let elapsedTimePublisher = CurrentValueSubject<TimeInterval, Never>(0)
    private(set) var elapsed: AnyPublisher<TimeInterval, Never>

    private let statePublisher = CurrentValueSubject<State, Never>(.idle)
    private(set) var state: AnyPublisher<State, Never>

    private var cancellable = Set<AnyCancellable>()

    init() {
        self.elapsed = elapsedTimePublisher.eraseToAnyPublisher()
        self.state = statePublisher.eraseToAnyPublisher()
        self.track = trackPublisher.eraseToAnyPublisher()
        self.distance = distancePublisher.eraseToAnyPublisher()
        self.avgSpeed = avgSpeedPublisher.eraseToAnyPublisher()
        reset()
        self.state
            .sink { state in
                switch state {
                case .running:
                    UIApplication.shared.isIdleTimerDisabled = true
                case .idle, .paused, .stopped:
                    UIApplication.shared.isIdleTimerDisabled = false
                }
            }.store(in: &cancellable)
    }

    func reset() {
        startDate = 0
        pausedDate = 0
        stopDate = 0
        totalDistance = 0
        elevationGain = 0
    }

    func start() {
        startDate = Date.timeIntervalSinceReferenceDate
        statePublisher.send(.running)

        locationService.start()
        locationService.location
            .sink { [weak self] location in self?.handle(location: location) }
            .store(in: &cancellable)

        run()
    }

    func restart() {
        reset()
        start()
    }

    func pause(automatic: Bool = false) {
        locationService.stop()
        pausedDate = Date.timeIntervalSinceReferenceDate
        timerCancellable?.cancel()
        statePublisher.send(.paused(automatic))
    }

    func resume() {
        locationService.start()
        startDate += (Date.timeIntervalSinceReferenceDate - pausedDate)
        statePublisher.send(.running)
        run()
    }

    func stop() {
        locationService.stop()
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
        }.sink { [unowned self, elapsedTimePublisher] elapsed in
            elapsedTimePublisher.send(elapsed)
            self.duration = elapsed
        }
    }

    private func storeRide() {
        storageService.createNewRide(
            name: "Ride",
            summary: Summary(
                duration: duration,
                distance: totalDistance,
                avgSpeed: locations.average(by: \.speed),
                maxSpeed: locations.max(by: \.speed)?.speed ?? .zero,
                elevationGain: elevationGain
            ),
            locations: locations
        )
    }

    private func handle(location: CLLocation) {

        if elevationGainProcessor == nil {
            if let altitude = locations.last?.altitude {
                elevationGainProcessor = ElevationGainProcessor(initialAltitude: altitude)
            }
        } else {
            self.elevationGain = elevationGainProcessor!.process(input: location.altitude)
        }

        self.locations.append(location)

        guard self.locations.count >= 2 else {
            return
        }

        // Calculate Polyline
        let locationA = self.locations[self.locations.count - 2]
        let locationB = self.locations[self.locations.count - 1]
        var coordinates = [locationA, locationB].map { $0.coordinate }
        self.trackPublisher.send(MKPolyline(coordinates: &coordinates, count: 2))
        let delta = locationA.distance(from: locationB)
        self.totalDistance += delta
        self.distancePublisher.send(self.totalDistance)

        let avgSpeed = self.totalDistance / self.duration
        self.avgSpeedPublisher.send(avgSpeed)
    }
}
