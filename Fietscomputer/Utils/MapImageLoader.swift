//
//  MapImageLoader.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 19/06/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import UIKit
import Combine
import struct CoreLocation.CLLocationCoordinate2D

class MapImageLoader: ObservableObject {

    @Published var mapImage: UIImage?

    private let center: CLLocationCoordinate2D
    private var snapshotter: Cancellable?
    private let snapshotService: MapSnapshotProtocol = MapKitSnapshot()

    init(center: CLLocationCoordinate2D) {
        self.center = center
    }

    func start() {
        guard mapImage == nil else {
            return
        }
        snapshotter = snapshotService
            .makeSnapshot(center, size: CGSize(width: 120 * 3, height: 80 * 3))
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .assign(to: \.mapImage, on: self)
    }

    func stop() {
        // snapshotter?.cancel()
    }
}
