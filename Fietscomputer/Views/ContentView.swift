//
//  SpeedView.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 30/04/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import SwiftUI
import SplitView

class NotificationViewModel: ViewModel, ObservableObject {

    @Published var message = ""
    @Published var showNotification = false

    override init() {
        super.init()

        rideService.state
            .sink {
                switch $0 {
                case .idle, .stopped:
                    ()
                case .paused:
                    self.show(message: "Ride has been paused")
                case .running:
                    self.show(message: "Ride has been started")
                }
        }
        .store(in: &cancellables)
    }

    func show(message: String) {
        self.message = message
        withAnimation {
            self.showNotification = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation {
                self.showNotification = false
            }
        }
    }
}

struct ContentView: View {

    @ObservedObject var sliderViewModel = SliderControlViewModel(middle: 0.5, range: 0.35...0.85)
    @ObservedObject var contentViewModel: ContentViewModel
    @ObservedObject var notificationViewModel = NotificationViewModel()

    var body: some View {
        GeometryReader { geometry in
            SplitView(
                viewModel: self.sliderViewModel,
                controlView: { SliderControlView() },
                topView: { MapView(viewModel: self.contentViewModel.mapViewModel) },
                bottomView: {
                    VStack(spacing: 0) {
                        GaugesWithIndicatorView(viewModel: self.contentViewModel)
                        ActionButton(goViewModel: self.contentViewModel.goButtonViewModel,
                                     stopViewModel: self.contentViewModel.stopButtonViewModel) { index in
                            switch index {
                            case .right:
                                self.contentViewModel.startPauseRide()
                            case .left:
                                self.contentViewModel.stopRide()
                            }
                        }
                        .frame(height: 96)
                        .padding([.bottom], 8)
                        Rectangle()
                            .frame(height: geometry.safeAreaInsets.bottom)
                            .foregroundColor(.white)
                    }
                    .background(Color(UIColor.systemBackground))
                }
            )
        }
        .notify(isShowing: notificationViewModel.showNotification) { [notificationViewModel] in
            Text(notificationViewModel.message)
        }
        .edgesIgnoringSafeArea([.horizontal, .bottom])
    }
}
