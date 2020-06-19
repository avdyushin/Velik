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

    init(ride: Ride) {
        self.objectID = ride.objectID
        self.rideViewModel = RideViewModel(
            createdAt: ride.createdAt,
            summary: ride.asRideSummary()
        )
    }

    func delete() {
        storage.deleteRide(objectID: objectID)
    }
}
