//
//  RideViewDetails.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 18/06/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import SwiftUI
import Combine
import Injected
import class CoreData.NSManagedObjectID
import struct CoreLocation.CLLocationCoordinate2D

struct RideViewDetails: View {

    let viewModel: RideDetailsViewModel
    @State private var confirmDelete = false
    @State private var sharePresented = false

    var body: some View {
        GeometryReader { [viewModel] geometry in
            ScrollView {
                VStack(alignment: .leading) {
                    AsyncMapImage(uuid: viewModel.rideViewModel.uuid,
                                  region: viewModel.rideViewModel.mapRegion,
                                  size: viewModel.mapSize,
                                  processor: viewModel.rideViewModel.mapProcessor()) {
                                    Rectangle() // placeholder
                                        .foregroundColor(Color(UIColor.systemFill))
                    }.frame(width: geometry.size.width, height: geometry.size.width/1.5)
                    Text(Strings.elevation).padding()
                    LineChartView(values: viewModel.rideViewModel.elevations,
                                  fillStyle: viewModel.chartFillStyle)
                        .animation(.easeInOut(duration: 2/3))
                        .frame(width: geometry.size.width) // Fix animation inside ScrollView
                        .frame(height: 180)
                    RideFullSummaryView(viewModel: viewModel.rideViewModel)
                    Text(Strings.speed).padding()
                    if viewModel.isChartVisible(.speed) {
                        LineChartView(values: viewModel.rideViewModel.speed,
                                      fillStyle: viewModel.chartFillStyle)
                            .frame(width: geometry.size.width, height: 100)
                    } else {
                        Text(Strings.no_data_available)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .padding(32)
                    }
                }
            }
        }.actionSheet(isPresented: $confirmDelete) { () -> ActionSheet in
            ActionSheet(
                title: Text(Strings.remove_ride_message),
                buttons: [
                    .destructive(Text(Strings.confirm_delete)) { self.viewModel.delete() },
                    .cancel()
                ]
            )
        }.sheet(isPresented: $sharePresented) {
            ShareSheet(activityItems: [self.viewModel.exportURL])
        }.navigationBarItems(
            trailing:
            HStack {
                Button(
                    action: { self.viewModel.export() },
                    label: { Image(systemName: "square.and.arrow.up") }
                )
                Spacer(minLength: 16)
                Button(
                    action: { self.confirmDelete.toggle() },
                    label: {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                )
            }
        ).onReceive(viewModel.$exportURL) {
            if $0 != nil { self.sharePresented.toggle() }
        }
    }
}
