//
//  GPXImporter.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 24/06/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import Combine
import Foundation

protocol DataImporter {
    var availableGPX: AnyPublisher<GPX, Never> { get }

    func `import`(url: URL) throws
    func save()
}

struct GPXImporter: DataImporter {

    private let available = PassthroughSubject<GPX, Never>()
    let availableGPX: AnyPublisher<GPX, Never>

    init() {
        availableGPX = available.eraseToAnyPublisher()
    }

    func `import`(url: URL) throws {
        let gpx = try GPX(contentsOf: url)
        available.send(gpx)
        debugPrint("Got \(gpx.points.count)")
    }

    func save() {
        debugPrint("Save me")
    }
}
