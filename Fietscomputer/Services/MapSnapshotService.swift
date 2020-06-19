//
//  MapSnapshotService.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 19/06/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import UIKit
import MapKit
import Combine
import struct CoreLocation.CLLocationCoordinate2D

protocol MapSnapshotProtocol {
    func makeSnapshot(_ center: CLLocationCoordinate2D, size: CGSize) -> AnyPublisher<UIImage?, Error>
}

class MapKitSnapshot: MapSnapshotProtocol {

    func makeSnapshot(_ center: CLLocationCoordinate2D, size: CGSize) -> AnyPublisher<UIImage?, Error> {
        MKMapSnapshotter.Publisher(
            center: center,
            latitudinalMeters: 800,
            longitudinalMeters: 1200
        ).eraseToAnyPublisher()
    }
}
