//
//  SpeedView.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 30/04/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import SwiftUI
import SplitView

struct ContentView: View {

    @ObservedObject var sliderViewModel = SliderControlViewModel(middle: 0.5, range: 0.3...0.85)
    @ObservedObject var contentViewModel: ContentViewModel

    var body: some View {
        GeometryReader { geometry in
            SplitView(
                viewModel: self.sliderViewModel,
                controlView: { SliderControlView() },
                topView: { MapView(viewModel: self.contentViewModel.mapViewModel) },
                bottomView: {
                    VStack(spacing: 0) {
                        GaugesWithIndicatorView(viewModel: self.contentViewModel)
                        ActionButton(viewModel: self.contentViewModel.buttonViewModel) { index in
                            switch index {
                            case .right:
                                self.contentViewModel.startPauseRide()
                            case .left:
                                self.contentViewModel.stopRide()
                            }
                        }
                        Rectangle()
                            .frame(height: geometry.safeAreaInsets.bottom)
                            .foregroundColor(.green)
                    }
                    .background(Color(UIColor.systemBackground))
                }
            )
        }.edgesIgnoringSafeArea([.horizontal, .bottom])
    }
}
