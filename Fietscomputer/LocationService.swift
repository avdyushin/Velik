//
//  LocationService.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 30/04/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import MapKit
import Combine
import CoreLocation

protocol Service {
    func start()
    func stop()
}

class LocationService: NSObject, Service {

    private let manager: CLLocationManager
    private var cancellables = Set<AnyCancellable>()
    private var locations = [CLLocation]()
    private var totalDistance: CLLocationDistance = 0

    private let speedPublisher = CurrentValueSubject<CLLocationSpeed, Never>(0)
    private(set) var speed: AnyPublisher<CLLocationSpeed, Never>

    private let trackPublisher = PassthroughSubject<MKPolyline, Never>()
    private(set) var track: AnyPublisher<MKPolyline, Never>

    private let distancePublisher = CurrentValueSubject<CLLocationDistance, Never>(0)
    private(set) var distance: AnyPublisher<CLLocationDistance, Never>

    private let locationPublisher = PassthroughSubject<CLLocation, Never>()

    private let startedPublisher = PassthroughSubject<Bool, Never>()
    private(set) var started: AnyPublisher<Bool, Never>

    init(manager: CLLocationManager = CLLocationManager()) {
        self.manager = manager
        self.manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        self.speed = speedPublisher.eraseToAnyPublisher()
        self.track = trackPublisher.eraseToAnyPublisher()
        self.started = startedPublisher.eraseToAnyPublisher()
        self.distance = distancePublisher.eraseToAnyPublisher()
        super.init()
        self.manager.delegate = self
        self.locationPublisher.sink { location in
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
    }

    func start() {
        manager.startUpdatingLocation()
        manager.startUpdatingHeading()
        startedPublisher.send(true)
        debugPrint("\(self) started")
    }

    func stop() {
        manager.stopUpdatingLocation()
        manager.stopUpdatingHeading()
        startedPublisher.send(false)
    }
}

extension LocationService: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let last = locations.last else {
            return
        }
        speedPublisher.send(last.speed)
        locations.forEach {
            locationPublisher.send($0)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        debugPrint(error)
    }
}
