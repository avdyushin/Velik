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
            VStack {
                AsyncMapImage(uuid: viewModel.rideViewModel.uuid,
                              region: viewModel.rideViewModel.mapRegion,
                              size: viewModel.mapSize,
                              processor: viewModel.rideViewModel.mapProcessor()) {
                    Rectangle() // placeholder
                        .foregroundColor(Color(UIColor.systemFill))
                }.frame(
                    minWidth: 0,
                    maxWidth: .infinity,
                    minHeight: 0,
                    maxHeight: geometry.size.width/1.5,
                    alignment: .top
                )
                RideFullSummaryView(viewModel: viewModel.rideViewModel)
                Spacer()
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
