//
//  RideCellView.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 19/06/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import SwiftUI
import struct CoreLocation.CLLocationCoordinate2D

struct RideSummaryView: View {
    var viewModel: RideViewModel
    var body: some View {
        HStack {
            VStack(spacing: 8) {
                ValueDescriptionView(text: viewModel.duration, details: viewModel.durationLabel)
                ValueDescriptionView(text: viewModel.avgSpeed, details: viewModel.avgSpeedLabel)
            }
            VStack(spacing: 8) {
                ValueDescriptionView(text: viewModel.distance, details: viewModel.distanceLabel)
                ValueDescriptionView(text: viewModel.maxSpeed, details: viewModel.maxSpeedLabel)
            }
        }
    }
}

struct RideCellView: View {

    var viewModel: RideViewModel

    var body: some View {
        VStack(alignment: .trailing) {
            Text(viewModel.date)
                .font(.caption)
                .foregroundColor(.secondary)
            HStack(alignment: .top) {
                AsyncMapImage(center: CLLocationCoordinate2D(latitude: 51.94, longitude: 4.49)) {
                    Rectangle()
                        .foregroundColor(Color(UIColor.systemFill))
                }.frame(width: 120, height: 80, alignment: .leading)
                VStack(alignment: .trailing, spacing: 8) {
                    RideSummaryView(viewModel: viewModel)
                }.frame(minWidth: 0, maxWidth: .infinity)
            }
        }
    }
}

struct RideCellViewPreview: PreviewProvider {
    static var previews: some View {
        VStack {
            RideCellView(viewModel: RideViewModel(
                createdAt: Date(),
                summary: RideService.Summary(
                    duration: 30,
                    distance: 20,
                    avgSpeed: 5,
                    maxSpeed: 10
                )
            ))
            RideCellView(viewModel: RideViewModel(
                createdAt: Date().advanced(by: -60*60*20),
                summary: RideService.Summary(
                    duration: 30023,
                    distance: 123456,
                    avgSpeed: 7,
                    maxSpeed: 9
                )
            ))
            RideCellView(viewModel: RideViewModel(
                createdAt: Date().advanced(by: -60*60*24*5),
                summary: RideService.Summary(
                    duration: 3022,
                    distance: 2000000,
                    avgSpeed: 20,
                    maxSpeed: 30
                )
            ))
        }
    }
}
