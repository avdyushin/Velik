//
//  RideDetailsViewModel.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 19/06/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import SwiftUI
import Combine
import CoreData
import Injected
import CoreLocation

class RideDetailsViewModel: ObservableObject {

    enum ChartType {
        case elevation
        case speed
    }

    @Injected private var storage: StorageService
    @Injected private var exporter: GPXExporter

    private var cancellable = Set<AnyCancellable>()

    @Published var exportURL: URL?

    let objectID: NSManagedObjectID
    var rideViewModel: RideViewModel
    let mapSize = CGSize(width: 240*3, height: 160*3)

    let chartFillStyle = LinearGradient(
        gradient: Gradient(colors: [
            Color(UIColor.fdAndroidGreen),
            Color.green
        ]),
        startPoint: UnitPoint(x: 0, y: 0),
        endPoint: UnitPoint(x: 0, y: 1)
    )

    init(ride: Ride) {
        self.objectID = ride.objectID
        self.rideViewModel = RideViewModel(
            uuid: ride.id!,
            name: ride.name,
            createdAt: ride.createdAt!,
            summary: ride.asRideSummary(),
            locations: ride.locations()
        )
    }

    func delete() {
        storage.deleteRide(objectID: objectID)
    }

    func isChartVisible(_ type: ChartType) -> Bool {
        switch type {
        case .elevation:
            return rideViewModel.elevationGainValue != .zero && !rideViewModel.elevations.isEmpty
        case .speed:
            return rideViewModel.avgSpeedValue != .zero && !rideViewModel.speed.isEmpty
        }
    }

    func export() {
        exporter
            .export(rideUUID: rideViewModel.uuid)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { url in self.exportURL = url }
            ).store(in: &cancellable)
    }
}
