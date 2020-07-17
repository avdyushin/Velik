//
//  GPXExporter.swift
//  Velik
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

extension FileManager {
    func documents() -> URL? {
        urls(for: .documentDirectory, in: .userDomainMask).first
    }

    func createLink(to fileURL: URL, with name: String) throws -> URL {
        let linkURL = temporaryDirectory.appendingPathComponent(name)
        if fileExists(atPath: linkURL.path) {
            try removeItem(at: linkURL)
        }
        try linkItem(at: fileURL, to: linkURL)
        return linkURL
    }
}

class GPXExporter: DataExporter {

    enum GPXError: Error {
        case noDocumentsDirectory
        case rideNotFound(UUID)
    }

    @Injected private var storage: StorageService

    func export(rideUUID uuid: UUID) -> AnyPublisher<URL, Error> {
        storage
            .findRide(by: uuid)
            .tryMap { ride in
                guard let track = ride.track else {
                    throw GPXError.rideNotFound(uuid)
                }
                let gpxTrack = GPXTrack(track: track)
                let xmlRoot = try XMLEncoder.encode(gpxTrack, root: "gpx")
                guard let docs = FileManager.default.documents() else {
                        throw GPXError.noDocumentsDirectory
                }
                let url = docs.appendingPathComponent("Track").appendingPathExtension("gpx")
                let xml = xmlRoot.asString()
                try xml.write(to: url, atomically: true, encoding: .utf8)
                let date = ride.createdAt ?? Date()
                let dateString = Formatters.fileDateFormatter.string(from: date)
                let linkName = "Track_\(dateString).gpx"
                let link = try FileManager.default.createLink(to: url, with: linkName)
                return link
            }.eraseToAnyPublisher()
    }
}
