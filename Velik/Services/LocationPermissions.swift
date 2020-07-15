//
//  LocationPermissions.swift
//  Velik
//
//  Created by Grigory Avdyushin on 01/05/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import Combine
import CoreLocation

class LocationPermissions: NSObject, Permissions {

    typealias Status = CLAuthorizationStatus

    private let manager: CLLocationManager
    private var cancellable = Set<AnyCancellable>()
    private let statusPublisher = CurrentValueSubject<CLAuthorizationStatus, Never>(
        CLLocationManager.authorizationStatus()
    )
    private(set) var status: AnyPublisher<CLAuthorizationStatus, Never>

    init(manager: CLLocationManager = CLLocationManager()) {
        self.manager = manager
        self.status = statusPublisher.eraseToAnyPublisher()
        super.init()
        self.manager.delegate = self
    }

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
