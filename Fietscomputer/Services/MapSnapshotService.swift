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
        Future<UIImage?, Error> { promise in
            let snapshotter = MKMapSnapshotter(options:
                .init(region: MKCoordinateRegion(
                    center: center,
                    latitudinalMeters: 1200,
                    longitudinalMeters: 800
                ))
            )
            snapshotter.start { snapshot, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(snapshot?.image))
                }
            }
        }.eraseToAnyPublisher()
    }
}

extension MKMapSnapshotter.Options {
    convenience init(region: MKCoordinateRegion) {
        self.init()
        self.region = region
    }
}
