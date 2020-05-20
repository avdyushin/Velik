//
//  SpeedView.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 30/04/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import SwiftUI

struct ContentView: View {

    @ObservedObject var viewModel: ContentViewModel
    @ObservedObject var position = SliderPosition()

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    VStack {
                        MapView(viewModel: self.viewModel.mapViewModel)
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                        VStack {
                            SpeedView(viewModel: self.viewModel.speedViewModel).frame(minHeight: 0, maxHeight: .infinity)
                            HStack {
                                GaugeView(viewModel: self.viewModel.durationViewModel).frame(minWidth: 0, maxWidth: .infinity)
                                GaugeView(viewModel: self.viewModel.distanceViewModel).frame(minWidth: 0, maxWidth: .infinity)
                            }.padding(EdgeInsets(top: 0, leading: 0, bottom: 18, trailing: 0))
                            Button(action: self.viewModel.startPauseRide) {
                                Text(self.viewModel.buttonTitle)
                            }
                            .foregroundColor(.green)
                            .buttonStyle(ActionButtonStyle())
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: geometry.safeAreaInsets.bottom, trailing: 0))
                            .background(Color.green)
                        }
                        .frame(height: geometry.size.height * 0.5 - 10 /* ? */ - self.position.value)
                        .background(Color(UIColor.systemBackground))
                    }
                }
                SliderView(position: self.position, geometry: geometry, range: 0.3...0.8) {
                    Group {
                        ZStack(alignment: .bottom) {
                            Rectangle()
                                .foregroundColor(Color(UIColor.systemBackground))
                                .frame(minWidth:0, maxWidth: .infinity, minHeight: 6, maxHeight: 6)
                                .shadow(color: Color.black.opacity(0.05), radius: 1, x: 0, y: -5)
                            RoundedRectangle(cornerRadius: 5)
                                .fill()
                                .frame(width: 48, height: 3)
                        }
                    }
                    .foregroundColor(Color(UIColor.separator))
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .background(Color.clear)
                }
            }
        }.edgesIgnoringSafeArea([.horizontal, .bottom])
    }
}
