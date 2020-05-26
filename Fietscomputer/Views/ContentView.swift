//
//  SpeedView.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 30/04/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import SwiftUI
import PageView
import SplitView

struct SliderControlView: View {

    var body: some View {
        Group {
            Rectangle()
                .foregroundColor(Color(UIColor.systemBackground))
                .frame(minWidth:0, maxWidth: .infinity, minHeight: 6, maxHeight: 6)
                .shadow(color: Color.black.opacity(0.05), radius: 1, x: 0, y: -5)
            RoundedRectangle(cornerRadius: 5)
                .foregroundColor(Color(UIColor.separator))
                .frame(width: 48, height: 3)
        }
    }
}

struct ActionButton: View {

    @ObservedObject var viewModel: ContentViewModel

    var body: some View {
        Button(action: viewModel.startPauseRide) {
            Text(viewModel.buttonTitle)
        }
        .foregroundColor(.green)
        .buttonStyle(ActionButtonStyle())
    }
}

struct GaugesView: View {

    @ObservedObject var viewModel: ContentViewModel
    @State private var pageIndex: Int = 0

    var body: some View {
        PageView(index: self.$pageIndex) {
            PageView.Page {
                AnyView(
                    ZStack {
                        VStack {
                            SpeedView(viewModel: viewModel.speedViewModel).frame(minHeight: 0, maxHeight: .infinity)
                            HStack {
                                GaugeView(viewModel: viewModel.durationViewModel).frame(minWidth: 0, maxWidth: .infinity)
                                GaugeView(viewModel: viewModel.distanceViewModel).frame(minWidth: 0, maxWidth: .infinity)
                            }.padding(EdgeInsets(top: 0, leading: 0, bottom: 18, trailing: 0))
                        }
                    }.background(Color(UIColor.systemBackground))
                )
            }
            PageView.Page {
                AnyView(
                    ZStack {
                        Rectangle().fill().foregroundColor(Color(UIColor.systemBackground))
                        VStack(spacing: 16) {
                            GaugeView(viewModel: viewModel.durationViewModel).frame(minWidth: 0, maxWidth: .infinity)
                            GaugeView(viewModel: viewModel.distanceViewModel).frame(minWidth: 0, maxWidth: .infinity)
                        }
                    }
                )
            }
        }
    }
}

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
                        GaugesView(viewModel: self.contentViewModel)
                        ActionButton(viewModel: self.contentViewModel)
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
