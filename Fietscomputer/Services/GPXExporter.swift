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
                    let encoder = XMLEncoder(node: XMLElement("gpx"))
                    try? track.encode(to: encoder)
                    let root = encoder.node
                    debugPrint(root)
                }
            })
            .store(in: &cancellables)
    }
}
