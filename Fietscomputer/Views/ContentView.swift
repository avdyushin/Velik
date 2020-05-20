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
                controlView: {
                    Group {
                        Rectangle()
                            .foregroundColor(Color(UIColor.systemBackground))
                            .frame(minWidth:0, maxWidth: .infinity, minHeight: 6, maxHeight: 6)
                            .shadow(color: Color.black.opacity(0.05), radius: 1, x: 0, y: -5)
                        RoundedRectangle(cornerRadius: 5)
                            .fill()
                            .frame(width: 48, height: 3)
                    }
                    .foregroundColor(Color(UIColor.separator))
                    .background(Color.clear)
                },
                topView: { MapView(viewModel: self.contentViewModel.mapViewModel) },
                bottomView: {
                    VStack {
                        SpeedView(viewModel: self.contentViewModel.speedViewModel).frame(minHeight: 0, maxHeight: .infinity)
                        HStack {
                            GaugeView(viewModel: self.contentViewModel.durationViewModel).frame(minWidth: 0, maxWidth: .infinity)
                            GaugeView(viewModel: self.contentViewModel.distanceViewModel).frame(minWidth: 0, maxWidth: .infinity)
                        }.padding(EdgeInsets(top: 0, leading: 0, bottom: 18, trailing: 0))
                        Button(action: self.contentViewModel.startPauseRide) {
                            Text(self.contentViewModel.buttonTitle)
                        }
                        .foregroundColor(.green)
                        .buttonStyle(ActionButtonStyle())
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: geometry.safeAreaInsets.bottom, trailing: 0))
                        .background(Color.green)
                    }
                    .background(Color(UIColor.systemBackground))
                }
            )
        }.edgesIgnoringSafeArea([.horizontal, .bottom])
    }
}
