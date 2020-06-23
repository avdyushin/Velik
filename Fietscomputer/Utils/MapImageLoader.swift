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
    private let processor: MapSnapshotProcessor
    private var snapshotter: Cancellable?
    private let snapshotService: MapSnapshotProtocol = MapKitSnapshot()

    init(center: CLLocationCoordinate2D, processor: MapSnapshotProcessor) {
        self.center = center
        self.processor = processor
    }

    func start() {
        guard mapImage == nil else {
            return
        }
        snapshotter = snapshotService
            .makeSnapshot(center, processor: processor)
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .assign(to: \.mapImage, on: self)
    }

    func stop() {
        // snapshotter?.cancel()
    }
}
