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
import CoreLocation

class RideDetailsViewModel: ObservableObject {

    @Injected var storage: StorageService

    let objectID: NSManagedObjectID
    var rideViewModel: RideViewModel
    let mapSize = CGSize(width: 240*3, height: 160*3)

    init(ride: Ride) {
        self.objectID = ride.objectID
        self.rideViewModel = RideViewModel(
            uuid: ride.id!,
            createdAt: ride.createdAt,
            summary: ride.asRideSummary(),
            locations: ride.locations()
        )
    }

    func delete() {
        storage.deleteRide(objectID: objectID)
    }
}
