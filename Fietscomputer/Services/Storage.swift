//
//  Storage.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 22/05/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import CoreData
import Foundation
import CoreDataStorage

extension CoreDataStorage {
    func update(_ block: @escaping (NSManagedObjectContext) -> Void) {
        _ = self.performInBackgroundAndSave { block($0) }
    }
}

class StorageService: Service {

    let shouldAutostart = true

    let storage = CoreDataStorage(container: NSPersistentContainer(name: "Fietscomputer"))

    func start() {
        debugPrint(storage)
    }
    func stop() { }

    func createNewRide(name: String, summary: RideService.Summary) {
        storage.update { context in
            let ride = Ride.create(name: name, context: context)
            ride.summary = RideSummary.create(context: context)
            ride.summary?.distance = summary.distance
            ride.summary?.duration = summary.duration
            ride.summary?.avgSpeed = summary.avgSpeed
            ride.summary?.maxSpeed = summary.maxSpeed
        }
    }
}
