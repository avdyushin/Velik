//
//  Permissions.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 30/04/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import UIKit
import Combine
import CoreLocation

protocol Permissions {
    associatedtype Status
    var status: AnyPublisher<Status, Never> { get }
    func request() -> Future<Status, Never>
}

class LocationPermissions: NSObject, Permissions {

    typealias Status = CLAuthorizationStatus

    let manager: CLLocationManager

    var cancellables = Set<AnyCancellable>()
    private let statusPublisher = PassthroughSubject<CLAuthorizationStatus, Never>()
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
                .store(in: &self.cancellables)
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
