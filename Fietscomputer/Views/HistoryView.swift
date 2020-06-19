//
//  HistoryView.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 18/06/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import SwiftUI

struct HistoryView: View {

    @ObservedObject var viewModel: HistoryViewModel
    @FetchRequest(sortDescriptors: Ride.sortDescriptors) var rides: FetchedResults<Ride>

    var body: some View {
        NavigationView {
            List(rides) { ride in
                NavigationLink(destination: RideView()) {
                    RideCellView(viewModel: RideViewModel(
                        createdAt: ride.createdAt,
                        summary: ride.asRideSummary()
                    )).padding([.bottom], 6)
                }
            }.listStyle(GroupedListStyle())
            .navigationBarTitle("Rides")
        }
    }
}
