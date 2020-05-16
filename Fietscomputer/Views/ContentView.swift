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

        rideService.state
            .map {
                switch $0 {
                case .idle, .stopped: return "Start"
                case .paused: return "Continue"
                case .running: return "Pause"
                }
            }
            .assign(to: \.buttonTitle, on: self)
            .store(in: &cancellables)
    }

    func startPauseRide() {
        rideService.toggle()
        debugPrint(buttonTitle)
    }
}

struct ActionButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(.headline))
            .foregroundColor(Color.white)
            .padding(12)
            .frame(minWidth: 0, maxWidth: .infinity)
            .background(
                Rectangle()
                    .fill()
                    .opacity(configuration.isPressed ? 0.8 : 1.0)
        )
    }
}

struct ContentView: View {

    @ObservedObject var viewModel: ContentViewModel

    var body: some View {
        GeometryReader { geometry in
            VStack {
                MapView(viewModel: self.viewModel.mapViewModel).frame(minHeight: 0, maxHeight: .infinity)
                SpeedView(viewModel: self.viewModel.speedViewModel).frame(minHeight: 0, maxHeight: .infinity)
                HStack {
                    GaugeView(viewModel: self.viewModel.durationViewModel).frame(minWidth: 0, maxWidth: .infinity)
                    GaugeView(viewModel: self.viewModel.distanceViewModel).frame(minWidth: 0, maxWidth: .infinity)
                }.padding(20)
                Button(action: self.viewModel.startPauseRide) {
                    Text(self.viewModel.buttonTitle)
                }
                .foregroundColor(.green)
                .buttonStyle(ActionButtonStyle())
                .padding(EdgeInsets(top: 0, leading: 0, bottom: geometry.safeAreaInsets.bottom, trailing: 0))
            }
        }.edgesIgnoringSafeArea(.bottom)
    }
}

struct ActionButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Text("OK")
            Button(action: {}) {
                Text("Start")
            }
            .foregroundColor(Color.yellow)
            .buttonStyle(ActionButtonStyle())
            Text("OK")
        }
    }
}
