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
            VStack(spacing: 0) {
                List(rides) { ride in
                    NavigationLink(
                        destination:
                        RideViewDetails(viewModel: RideDetailsViewModel(ride: ride))
                            .navigationBarTitle(Text(Strings.summary), displayMode: .inline)
                    ) {
                        RideCellView(viewModel: RideViewModel(ride: ride))
                            .padding([.bottom], 6)
                    }
                }
            }.navigationBarTitle(Text(Strings.rides), displayMode: .inline)
        }
    }
}
