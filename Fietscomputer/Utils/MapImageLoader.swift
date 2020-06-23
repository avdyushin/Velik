//
//  MapImageLoader.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 19/06/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import UIKit
import MapKit
import Combine

class MapImageLoader: ObservableObject {

    @Published var mapImage: UIImage?

    private let region: MKCoordinateRegion
    private let size: CGSize
    private let processor: MapSnapshotProcessor
    private var snapshotter: Cancellable?
    private let snapshotService: MapSnapshotProtocol = MapKitSnapshot()

    init(region: MKCoordinateRegion, size: CGSize, processor: MapSnapshotProcessor) {
        self.region = region
        self.size = size
        self.processor = processor
    }

    func start() {
        guard mapImage == nil else {
            return
        }
        snapshotter = snapshotService
            .makeSnapshot(region: region, size: size, processor: processor)
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .assign(to: \.mapImage, on: self)
    }

    func stop() {
        // snapshotter?.cancel()
    }
}
