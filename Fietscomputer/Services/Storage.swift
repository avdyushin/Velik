//
//  Storage.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 22/05/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import Combine
import CoreData
import Foundation
import CoreLocation
import CoreDataStorage

extension CoreDataStorage {
    func update(_ block: @escaping (NSManagedObjectContext) -> Void) {
        _ = self.performInBackgroundAndSave { block($0) }
    }
}

class StorageService: Service {

    let shouldAutostart = true
    let storage = CoreDataStorage(container: try! NSPersistentContainer("Fietscomputer"))

    func start() {
        debugPrint(storage)
    }

    func stop() { }

    func createNewRide(name: String, summary: RideService.Summary, locations: [CLLocation]) {
        storage.update { context in
            let ride = Ride.create(name: name, context: context)
            ride.summary = RideSummary.create(context: context)
            ride.summary?.distance = summary.distance
            ride.summary?.duration = summary.duration
            ride.summary?.avgSpeed = summary.avgSpeed
            ride.summary?.maxSpeed = summary.maxSpeed
            ride.summary?.elevationGain = summary.elevationGain
            ride.track = Track.create(name: name, context: context)
            locations.forEach {
                ride.track?.addTrackPoint(with: $0, context: context)
            }
            if let region = locations.region() {
                ride.track?.region = TrackRegion.create(region: region, context: context)
            }
        }
    }

    func deleteRide(objectID: NSManagedObjectID) {
        storage.update { context in
            context.delete(context.object(with: objectID))
        }
    }

    enum StorageError: Error {
        case itemNotFound(UUID)
    }

    func findRide(by uuid: UUID) -> AnyPublisher<Ride, Error> {
        let request: NSFetchRequest<Ride> = Ride.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@", "id"/*#keyPath(Ride.id)*/, uuid as CVarArg)
        return storage
            .fetch(request)
            .tryMap {
                guard let first = $0.first else {
                    throw StorageError.itemNotFound(uuid)
                }
                return first
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
