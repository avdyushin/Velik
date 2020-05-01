//
//  SpeedView.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 30/04/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import SwiftUI
import Combine

struct ContentView: View {

    @ObservedObject var mapViewModel: MapViewModel
    @ObservedObject var speedViewModel: SpeedViewModel
    @ObservedObject var durationViewModel: DurationViewModel
    @ObservedObject var distanceViewModel: DistanceViewModel

    var body: some View {
        VStack {
            MapView(viewModel: mapViewModel).frame(minHeight: 0, maxHeight: .infinity)
            SpeedView(viewModel: speedViewModel).frame(minHeight: 0, maxHeight: .infinity)
            HStack {
                GaugeView(viewModel: durationViewModel).frame(minWidth: 0, maxWidth: .infinity)
                GaugeView(viewModel: distanceViewModel).frame(minWidth: 0, maxWidth: .infinity)
            }.padding(20)
        }
    }
}
