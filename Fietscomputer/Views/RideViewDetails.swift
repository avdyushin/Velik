//
//  RideViewDetails.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 18/06/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import SwiftUI
import Injected
import class CoreData.NSManagedObjectID
import struct CoreLocation.CLLocationCoordinate2D

struct RideViewDetails: View {

    let viewModel: RideDetailsViewModel
    @State private var confirmDelete = false

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
                    }.frame(
                        minWidth: 0,
                        maxWidth: .infinity,
                        minHeight: geometry.size.width/1.5,
                        maxHeight: geometry.size.width/1.5,
                        alignment: .top
                    )
                    Text(Strings.elevation).padding()
                    LineChartView(values: viewModel.rideViewModel.locations.lazy.map { $0.altitude })
                        .frame(width: geometry.size.width) // Fix animation inside ScrollView
                        .frame(minHeight: 180, maxHeight: 180)
                    RideFullSummaryView(viewModel: viewModel.rideViewModel)
//                    Text(Strings.speed).padding()
//                    LineChartView(values: viewModel.rideViewModel.locations.lazy.map { $0.speed })
//                        .frame(minHeight: 180, maxHeight: 180)
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
        }.navigationBarItems(
            trailing: Button(
                action: { self.confirmDelete.toggle() },
                label: {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            )
        )
    }
}
