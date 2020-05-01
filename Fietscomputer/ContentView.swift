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

    var body: some View {
        VStack {
            MapView(viewModel: mapViewModel).frame(minHeight: 0, maxHeight: .infinity)
            SpeedView(viewModel: speedViewModel).frame(minHeight: 0, maxHeight: .infinity)
            DurationView(viewModel: durationViewModel).padding(20)
        }
    }
}
