//
//  GPXImporter.swift
//  Velik
//
//  Created by Grigory Avdyushin on 24/06/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import Combine
import Injected
import Foundation
import CoreLocation

protocol DataImporter {
    var availableGPX: AnyPublisher<GPXTrack, Never> { get }

    func `import`(url: URL) throws
    func save()
}

class GPXImporter: DataImporter {

    @Injected private var storage: StorageService

    private let available = PassthroughSubject<GPXTrack, Never>()
    let availableGPX: AnyPublisher<GPXTrack, Never>
    var gpx: GPXTrack?

    init() {
        availableGPX = available.eraseToAnyPublisher()
    }

    func `import`(url: URL) throws {
        let xml = try String(contentsOf: url)
        let gpx: GPXTrack = try XMLDecoder.decode(xml)
        available.send(gpx)
        self.gpx = gpx
    }

    func save() {
        guard let gpx = gpx, !gpx.locations.isEmpty else {
            return
        }

        let duration: TimeInterval
        if
            let minTimestamp = gpx.locations.min(by: \.timestamp)?.timestamp,
            let maxTimestamp = gpx.locations.max(by: \.timestamp)?.timestamp {
            duration = minTimestamp.distance(to: maxTimestamp)
        } else {
            duration = 0
        }

        var current = gpx.locations.first!
        var distance: CLLocationDistance = 0.0
        gpx.locations.dropFirst().forEach {
            distance += current.distance(from: $0)
            current = $0
        }

        let avgSpeed = gpx.locations.average(by: \.speed)
        let maxSpeed = gpx.locations.max(by: \.speed)?.speed ?? .zero

        current = gpx.locations.first!
        var elevationGain: CLLocationDistance = 0.0
        gpx.locations.dropFirst().forEach {
            elevationGain += max(0, current.altitude - $0.altitude)
            current = $0
        }

        storage.createNewRide(
            name: gpx.name ?? "Untitled",
            summary: RideService.Summary(
                duration: duration,
                distance: distance,
                avgSpeed: avgSpeed,
                maxSpeed: maxSpeed,
                elevationGain: elevationGain
            ),
            locations: gpx.locations,
            createdAt: gpx.timestamp
        )
    }
}
