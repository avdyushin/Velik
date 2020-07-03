//
//  GPXExporter.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 01/07/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import Combine
import Injected
import Foundation

protocol DataExporter {
    func export(rideUUID: UUID) -> AnyPublisher<URL, Error>
}

class GPXExporter: DataExporter {

    enum GPXError: Error {
        case noDocumentsDirectory
    }

    @Injected private var storage: StorageService

    func export(rideUUID uuid: UUID) -> AnyPublisher<URL, Error> {
        storage
            .findRide(by: uuid)
            .compactMap { $0.track }
            .tryMap { track in
                let gpxTrack = GPXTrack(track: track)
                let xmlRoot = try XMLEncoder.encode(gpxTrack, root: "gpx")
                guard let docs = FileManager
                    .default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                        throw GPXError.noDocumentsDirectory
                }
                let url = docs.appendingPathComponent("Track").appendingPathExtension("gpx")
                let xml = xmlRoot.asString()
                try xml.write(to: url, atomically: true, encoding: .utf8)
                return url
            }.eraseToAnyPublisher()
    }
}
