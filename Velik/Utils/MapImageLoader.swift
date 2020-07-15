//
//  MapImageLoader.swift
//  Velik
//
//  Created by Grigory Avdyushin on 19/06/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import UIKit
import MapKit
import Combine

class MapImageLoader: ObservableObject {

    @Published var mapImage: UIImage?

    private let key: MapImageCache.Key
    private let region: MKCoordinateRegion
    private let size: CGSize
    private let processor: MapSnapshotProcessor
    private var snapshot: Cancellable?
    private let snapshotService: MapSnapshotProtocol = MapKitSnapshot()

    init(uuid: UUID, region: MKCoordinateRegion, size: CGSize, processor: MapSnapshotProcessor) {
        self.key = MapImageCache.key(uuid: uuid, size: size)
        self.region = region
        self.size = size
        self.processor = processor
    }

    func start() {
        guard mapImage == nil else {
            return
        }

        guard MapImageCache.inMemory[key] == nil else {
            mapImage = MapImageCache.inMemory[key]
            return
        }

        snapshot = snapshotService
            .makeSnapshot(region: region, size: size, processor: processor)
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink {
                self.mapImage = $0
                MapImageCache.inMemory[self.key] = $0
            }
    }

    func stop() {
        snapshot?.cancel()
    }
}
