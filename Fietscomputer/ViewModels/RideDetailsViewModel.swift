//
//  RideDetailsViewModel.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 19/06/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import SwiftUI
import CoreData
import Injected

class RideDetailsViewModel: ObservableObject {

    @Injected var storage: StorageService

    let objectID: NSManagedObjectID
    var rideViewModel: RideViewModel

    var tracks: String
    var points: String

    init(ride: Ride) {
        self.objectID = ride.objectID
        self.rideViewModel = RideViewModel(
            createdAt: ride.createdAt,
            summary: ride.asRideSummary()
        )
        self.tracks = "Tracks: \(ride.tracks?.count ?? 0)"
        if let track = ride.tracks?.allObjects.first as? Track {
            self.points = "Points: \(track.points?.count ?? 0)"
        } else {
            self.points = "None"
        }
    }

    func delete() {
        storage.deleteRide(objectID: objectID)
    }
}
