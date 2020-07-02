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
    func export(rideUUID: UUID) throws
}

class GPXExporter: DataExporter {

    private var cancellables = Set<AnyCancellable>()
    @Injected private var storage: StorageService

    func export(rideUUID uuid: UUID) throws {
        debugPrint("Export", uuid)
        storage
            .findRide(by: uuid)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    debugPrint("error", error)
                case .finished: ()
                }
            }, receiveValue: { ride in
                debugPrint("We have ride!", String(describing: ride.name))
                if let track = ride.track {
                    let gpxTrack = GPXTrack(track: track)
                    do {
                        let xmlRoot = try XMLEncoder.encode(gpxTrack, root: "gpx")
                        debugPrint(xmlRoot.asString())
                        debugPrint(xmlRoot)
                    } catch {
                        debugPrint("error", error)
                    }
                }
            })
            .store(in: &cancellables)
    }
}
