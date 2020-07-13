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

class RideDetailsViewModel: RideViewModel {

    enum ChartType {
        case elevation
        case speed
    }

    @Injected private var storage: StorageService
    @Injected private var exporter: GPXExporter
    @Published var exportURL: URL?

    private var cancellable = Set<AnyCancellable>()

    override var mapSize: CGSize { CGSize(width: 240*3, height: 160*3) }

    lazy var yValues: [Double] = {
        []
    }()

    lazy var distanceMarkers: [CLLocationDistance] = {
        DistanceUtils
            .distanceMarkers(for: distanceValue, maxCount: 5)
            .map { $0.value }
    }()

    let chartFillStyle = LinearGradient(
        gradient: Gradient(colors: [
            Color(UIColor.fdAndroidGreen),
            Color.green
        ]),
        startPoint: UnitPoint(x: 0, y: 0),
        endPoint: UnitPoint(x: 0, y: 1)
    )

    override func mapProcessor() -> MapSnapshotProcessor {
        RideTrackDrawer({ [unowned self] in self.locations }) {
            TrackDrawer(style: .blue)
            // MarkerDrawer()
        }
    }

    func delete() {
        storage.deleteRide(objectID: ride.objectID)
    }

    func isChartVisible(_ type: ChartType) -> Bool {
        switch type {
        case .elevation:
            return elevationGainValue != .zero && !elevations.isEmpty
        case .speed:
            return avgSpeedValue != .zero && !speed.isEmpty
        }
    }

    func export() {
        exporter
            .export(rideUUID: uuid)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { url in self.exportURL = url }
            ).store(in: &cancellable)
    }

    func fixRegion() {
        if let region = self.ride.locations().region() {
            let id = ride.objectID
            _ = storage.storage.performInBackgroundAndSave { context -> Void in
                guard let ride = context.object(with: id) as? Ride, ride.track != nil else {
                    return
                }
                ride.track?.region = TrackRegion.create(region: region, context: context)
            }
        }
    }
}
