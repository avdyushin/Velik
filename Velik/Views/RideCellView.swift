//
//  RideCellView.swift
//  Velik
//
//  Created by Grigory Avdyushin on 19/06/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import SwiftUI
import CoreLocation

struct RideCellView: View {

    var viewModel: RideViewModel

    var body: some View {
        VStack {
            HStack(alignment: .firstTextBaseline) {
                Text(viewModel.title)
                    .lineLimit(3)
                Spacer()
                Text(viewModel.date)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            HStack(alignment: .top) {
                RideMapSnapshotView(viewModel: viewModel, mapSize: viewModel.mapSize)
                    .frame(width: 120, height: 80, alignment: .leading)
                RideSummaryView(viewModel: viewModel)
                    .frame(minWidth: 0, maxWidth: .infinity)
            }
        }
    }
}

//struct RideCellViewPreview: PreviewProvider {
//    static var previews: some View {
//        VStack {
//            RideCellView(viewModel: RideViewModel(
//                uuid: UUID(),
//                name: "Morning Ride",
//                createdAt: Date(),
//                summary: RideService.Summary(
//                    duration: 30,
//                    distance: 20,
//                    avgSpeed: 5,
//                    maxSpeed: 10,
//                    elevationGain: 100
//                ),
//                locations: []
//            ))
//            RideCellView(viewModel: RideViewModel(
//                uuid: UUID(),
//                name: "Evening Ride",
//                createdAt: Date().advanced(by: -60*60*20),
//                summary: RideService.Summary(
//                    duration: 30023,
//                    distance: 123456,
//                    avgSpeed: 7,
//                    maxSpeed: 9,
//                    elevationGain: 50
//                ),
//                locations: []
//            ))
//            RideCellView(viewModel: RideViewModel(
//                uuid: UUID(),
//                name: "Afternoon Ride",
//                createdAt: Date().advanced(by: -60*60*24*5),
//                summary: RideService.Summary(
//                    duration: 3022,
//                    distance: 2000000,
//                    avgSpeed: 20,
//                    maxSpeed: 30,
//                    elevationGain: 123
//                ),
//                locations: []
//            ))
//        }
//    }
//}
