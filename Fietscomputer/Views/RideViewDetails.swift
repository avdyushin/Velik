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
        VStack {
            AsyncMapImage(center: CLLocationCoordinate2D(latitude: 51.94, longitude: 4.49)) {
                Rectangle()
                    .foregroundColor(Color(UIColor.systemFill))
            }.frame(width: 240, height: 160, alignment: .leading)
            Divider()
            RideSummaryView(viewModel: viewModel.rideViewModel)
            Spacer()
            Text(viewModel.tracks)
            Text(viewModel.points)
            Button(
                action: {
                    self.confirmDelete.toggle()
                },
                label: {
                    Text(Strings.remove_ride)
                        .foregroundColor(.red)
                }
            )
            .padding()
        }.actionSheet(isPresented: $confirmDelete) { () -> ActionSheet in
            ActionSheet(
                title: Text(Strings.remove_ride_message),
                buttons: [
                    .destructive(Text(Strings.confirm_delete)) { self.viewModel.delete() },
                    .cancel()
                ]
            )
        }
    }
}
