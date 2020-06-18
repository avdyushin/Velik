//
//  SpeedView.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 30/04/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import SwiftUI
import SplitView

struct ContentView<Presenter: RootPresenting>: View {

    @ObservedObject var presenter: Presenter
    @State private var isPresented = false
    @Environment(\.managedObjectContext) var viewContext

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topLeading) {
                SplitView(
                    viewModel: self.presenter.viewModel.sliderViewModel,
                    controlView: { SliderControlView() },
                    topView: { MapView(viewModel: self.presenter.viewModel.mapViewModel) },
                    bottomView: {
                        VStack(spacing: 0) {
                            GaugesWithIndicatorView(viewModel: self.presenter.viewModel)
                            ActionButton(goViewModel: self.presenter.viewModel.goButtonViewModel,
                                         stopViewModel: self.presenter.viewModel.stopButtonViewModel) { intention in
                                switch intention {
                                case .startPause:
                                    self.presenter.viewModel.startPauseRide()
                                case .stop:
                                    self.presenter.viewModel.stopRide()
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
                Button(action: {
                    self.isPresented.toggle()
                }, label: {
                    Image(systemName: "line.horizontal.3")
                })
                    .buttonStyle(MenuButtonStyle())
                    .padding()
            }
        }
        .notify(isShowing: self.presenter.viewModel.notificationViewModel.showNotification) {
            Text(self.presenter.viewModel.notificationViewModel.message)
        }
        .sheet(isPresented: $isPresented) {
            HistoryView(viewModel: HistoryViewModel())
                .environment(\.managedObjectContext, self.viewContext)
        }
        .edgesIgnoringSafeArea([.horizontal, .bottom])
    }
}
