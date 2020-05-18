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

    @ObservedObject var viewModel: ContentViewModel
    @State var mapHeight: CGFloat = 0

    var body: some View {
        GeometryReader { geometry in
            VStack {
                MapView(viewModel: self.viewModel.mapViewModel)
                    .frame(minHeight: 0, idealHeight: self.mapHeight, maxHeight: .infinity)
                PullView(height: self.$mapHeight) {
                    Group {
                        SpeedView(viewModel: self.viewModel.speedViewModel).frame(minHeight: 0, maxHeight: .infinity)
                        HStack {
                            GaugeView(viewModel: self.viewModel.durationViewModel).frame(minWidth: 0, maxWidth: .infinity)
                            GaugeView(viewModel: self.viewModel.distanceViewModel).frame(minWidth: 0, maxWidth: .infinity)
                        }.padding(20)
                    }.background(Color.white)
                }
                Text("\(self.mapHeight)")
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
