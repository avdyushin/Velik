//
//  LocationPermissions.swift
//  Velik
//
//  Created by Grigory Avdyushin on 01/05/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import Combine
import Injected
import CoreLocation

class LocationPermissions: NSObject, Permissions {

    typealias Status = CLAuthorizationStatus

    var shouldAutostart = true

    private let manager: CLLocationManager
    private var cancellable = Set<AnyCancellable>()
    private let statusPublisher = CurrentValueSubject<CLAuthorizationStatus, Never>(
        CLLocationManager.authorizationStatus()
    )
    private(set) var status: AnyPublisher<CLAuthorizationStatus, Never>

    @Injected var locationService: LocationService

    init(manager: CLLocationManager = CLLocationManager()) {
        self.manager = manager
        self.status = statusPublisher.eraseToAnyPublisher()
        super.init()
        self.manager.delegate = self
        status
        .receive(on: DispatchQueue.main)
        .removeDuplicates()
        .sink { [weak self] status in
            switch status {
            case .authorizedAlways, .authorizedWhenInUse:
                self?.locationService.ready()
            case .restricted, .denied: ()
            default: ()
            }
        }
        .store(in: &cancellable)
    }

    func start() {
        _ = request()
    }

    func stop() { }

    func request() -> Future<Status, Never> {
        Future { [weak self] promise in
            guard let self = self else { return }

            self.status
                .sink { promise(.success($0)) }
                .store(in: &self.cancellable)
            self.manager.requestAlwaysAuthorization()
        }
    }
}

extension LocationPermissions: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        statusPublisher.send(status)
    }
}
