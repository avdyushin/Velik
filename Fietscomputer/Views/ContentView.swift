//
//  SpeedView.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 30/04/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import SwiftUI
import Combine

class ContentViewModel: ViewModel, ObservableObject {

    @ObservedObject var mapViewModel: MapViewModel
    @ObservedObject var speedViewModel: SpeedViewModel
    @ObservedObject var durationViewModel: DurationViewModel
    @ObservedObject var distanceViewModel: DistanceViewModel

    @Published var buttonTitle = "Start"

    init(mapViewModel: MapViewModel, speedViewModel: SpeedViewModel, durationViewModel: DurationViewModel,
         distanceViewModel: DistanceViewModel) {
        self.mapViewModel = mapViewModel
        self.speedViewModel = speedViewModel
        self.durationViewModel = durationViewModel
        self.distanceViewModel = distanceViewModel

        super.init()
        rideService.state.sink {
            switch $0 {
            case .idle, .stopped:
                self.buttonTitle = "Start"
            case .paused:
                self.buttonTitle = "Continue"
            case .running:
                self.buttonTitle = "Pause"
            }
        }.store(in: &cancellables)
    }

    func startPauseRide() {
        switch rideService.currentState {
        case .paused:
            speedViewModel.rideService.resume()
        case .running:
            speedViewModel.rideService.pause()
        case .idle, .stopped:
            speedViewModel.rideService.start()
        }
    }
}

struct ContentView: View {

    @ObservedObject var viewModel: ContentViewModel

    var body: some View {
        VStack {
            MapView(viewModel: viewModel.mapViewModel).frame(minHeight: 0, maxHeight: .infinity)
            SpeedView(viewModel: viewModel.speedViewModel).frame(minHeight: 0, maxHeight: .infinity)
            HStack {
                GaugeView(viewModel: viewModel.durationViewModel).frame(minWidth: 0, maxWidth: .infinity)
                GaugeView(viewModel: viewModel.distanceViewModel).frame(minWidth: 0, maxWidth: .infinity)
            }.padding(20)
            Button(action: viewModel.startPauseRide) {
                Text(viewModel.buttonTitle)
                    .font(.system(.title))
                    .foregroundColor(Color.white)
                    .padding(12)
                    .frame(minWidth: 0, maxWidth: .infinity)
            }
            .background(Color.green)
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}
