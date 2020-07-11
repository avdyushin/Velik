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

    var noDataText: some View {
        Text(Strings.no_data_available)
            .font(.caption)
            .foregroundColor(.secondary)
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding(32)
    }

    var body: some View {
        GeometryReader { [viewModel] geometry in
            ScrollView {
                VStack(alignment: .leading) {
                    // Map
                    NavigationLink(destination:
                        RideMapView(viewModel: viewModel)
                            .navigationBarTitle(Text(Strings.map), displayMode: .inline)
                    ) {
                        RideMapSnapshotView(viewModel: viewModel, mapSize: viewModel.mapSize)
                            .frame(width: geometry.size.width, height: geometry.size.width/1.5)
                    }.buttonStyle(PlainButtonStyle())
                    // Elevation
                    Text(Strings.elevation).padding()
                    if viewModel.isChartVisible(.elevation) {
                        LineChartView(values: viewModel.elevations,
                                      xValues: viewModel.xValues,
                                      xLabels: viewModel.distanceMarkers,
                                      fillStyle: viewModel.chartFillStyle)
                            .animation(.easeInOut(duration: 2/3))
                            .frame(width: geometry.size.width) // Fix animation inside ScrollView
                            .frame(height: 180)
                    } else { self.noDataText }

                    // Summary
                    RideFullSummaryView(viewModel: viewModel)

                    // Speed
                    Text(Strings.speed).padding()
                    if viewModel.isChartVisible(.speed) {
                        LineChartView(values: viewModel.speed,
                                      xValues: viewModel.xValues,
                                      xLabels: viewModel.distanceMarkers,
                                      fillStyle: viewModel.chartFillStyle)
                            .animation(.easeInOut(duration: 2/3))
                            .frame(width: geometry.size.width, height: 180)
                    } else { self.noDataText }
                }
            }
        }.actionSheet(isPresented: $confirmDelete) {
            ActionSheet(
                title: Text(Strings.remove_ride_message),
                buttons: [
                    .destructive(Text(Strings.confirm_delete)) { self.viewModel.delete() },
                    .cancel()
                ]
            )
        }.sheet(isPresented: $sharePresented) {
            ShareSheet(activityItems: [self.viewModel.exportURL as Any])
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
