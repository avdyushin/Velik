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

    private let speedPublisher = CurrentValueSubject<CLLocationSpeed, Never>(0)
    private(set) var speed: AnyPublisher<CLLocationSpeed, Never>

    private let trackPublisher = PassthroughSubject<MKPolyline, Never>()
    private(set) var track: AnyPublisher<MKPolyline, Never>

    private let startedPublisher = PassthroughSubject<Bool, Never>()
    private(set) var started: AnyPublisher<Bool, Never>

    init(manager: CLLocationManager = CLLocationManager()) {
        self.manager = manager
        self.manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        self.speed = speedPublisher.eraseToAnyPublisher()
        self.track = trackPublisher.eraseToAnyPublisher()
        self.started = startedPublisher.eraseToAnyPublisher()
        super.init()
        self.manager.delegate = self
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
        var coordinates = locations.map { $0.coordinate }
        let polyline = MKPolyline(coordinates: &coordinates, count: coordinates.count)
        trackPublisher.send(polyline)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        debugPrint("error | \(error)")
    }
}
