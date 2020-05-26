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
    @Binding var pageIndex: Int

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
            PageView.Page {
                AnyView(
                    ZStack {
                        Rectangle().fill().foregroundColor(Color(UIColor.systemBackground))
                        Text("Not implemented")
                    }
                )
            }
            PageView.Page {
                AnyView(
                    ZStack {
                        Rectangle().fill().foregroundColor(Color(UIColor.systemBackground))
                        Text("Not implemented")
                    }
                )
            }
        }
    }
}

struct PageIndicatorView: View {
    var index: Int
    var action: () -> Void

    var imageName: String {
        switch index {
        case 0: return "speedometer"
        case 1: return "timer"
        case 2: return "heart.circle"
        case 3: return "location.circle"
        default: return "circle"
        }
    }
    var body: some View {
        Button(action: { withAnimation { self.action() } }) {
            ZStack {
//                Rectangle()
//                    .foregroundColor(.clear)
//                    .frame(width: 24, height: 24)
                Image(systemName: imageName)
                    .resizable()
                    .frame(width: 24, height: 24)
            }
        }
    }
}

struct PageIndicatorModifier: ViewModifier {
    let index: Int
    @Binding var currentIndex: Int

    func body(content: Content) -> some View {
        content.opacity(index == currentIndex ? 1.0 : 0.3)
    }
}

struct GaugesWithIndicators: View {
    @ObservedObject var viewModel: ContentViewModel
    @State var pageIndex: Int = 0

    var body: some View {
        ZStack(alignment: .bottom) {
            GaugesView(viewModel: viewModel, pageIndex: self.$pageIndex)
                .padding(.bottom, 24)
            ZStack(alignment: .bottomTrailing) {
                HStack(spacing: 12) {
                    ForEach(0..<viewModel.numberOfPages) { index in
                        PageIndicatorView(index: index) { self.pageIndex = index }
                            .foregroundColor(.black)
                            .modifier(PageIndicatorModifier(index: index, currentIndex: self.$pageIndex))
                    }
                }.frame(minWidth: 0, maxWidth: .infinity)
//                Button(action: { debugPrint("Settings") }) {
//                    Image(systemName: "gear")
//                        .resizable()
//                        .frame(width: 24, height: 24)
//                }.padding(4)
            }.padding(.bottom, 12)
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
                        GaugesWithIndicators(viewModel: self.contentViewModel)
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
