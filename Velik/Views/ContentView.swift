//
//  SpeedView.swift
//  Velik
//
//  Created by Grigory Avdyushin on 30/04/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import SwiftUI
import Injected
import SplitView

extension AnyTransition {
    static var slideInOut: AnyTransition {
        AnyTransition.asymmetric(
            insertion: .move(edge: .bottom),
            removal: .move(edge: .bottom)
        )
            .combined(with: .scale(scale: 0.5))
            .combined(with: .opacity)
    }
}

struct ContentView<Presenter: RootPresenting>: View {

    @ObservedObject var presenter: Presenter
    @State private var isHistoryPresented = false
    @State private var isImportPresented = false
    @State private var isExportPresented = false
    @Environment(\.managedObjectContext) var viewContext

    @State private var importTitle: String = ""
    @Injected private var gpxImport: GPXImporter

    var splitView: some View {
        GeometryReader { geometry in
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
            })
        }
    }

    var menuButton: some View {
        Button(action: {
            self.isHistoryPresented.toggle()
        }, label: {
            Image(systemName: "line.horizontal.3")
        })
            .buttonStyle(MenuButtonStyle())
            .padding()
    }

    var importView: some View {
        GeometryReader { geometry in
            Group {
                VStack(spacing: 16) {
                    Text(Strings.import_gpx_message)
                        .bold()
                    Text(self.importTitle)
                    HStack {
                        Button(
                            action: { withAnimation { self.isImportPresented = false } },
                            label: { Text(Strings.no) }
                        )
                            .buttonStyle(AlertButtonStyle())
                            .foregroundColor(.red)
                        Button(
                            action: {
                                withAnimation {
                                    self.isImportPresented = false
                                }
                                self.gpxImport.save()
                        },
                            label: { Text(Strings.yes) }
                        )
                            .buttonStyle(AlertButtonStyle())
                            .foregroundColor(.green)
                    }
                }
                .padding()
                .frame(minWidth: 0, maxWidth: geometry.size.width, minHeight: 0, maxHeight: geometry.size.height / 2)
                .cornerRadius(18)
            }
            .background(Color(UIColor.secondarySystemBackground))
            .padding(48)
            .clipped()
            .shadow(radius: 6)
        }
    }

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            ZStack(alignment: .topLeading) {
                self.splitView
                self.menuButton
            }
            .blur(radius: self.isImportPresented ? 3 : 0)
            .opacity(self.isImportPresented ? 0.5 : 1.0)
            if self.isImportPresented {
                self.importView
                    .transition(.slideInOut)
            }
        }
        .sheet(isPresented: $isHistoryPresented) {
            HistoryView(viewModel: HistoryViewModel())
                .environment(\.managedObjectContext, self.viewContext)
        }
        .onReceive(gpxImport.availableGPX) { gpx in
            self.importTitle = gpx.name ?? "Unnamed"
            withAnimation { self.isImportPresented = true }
        }
        .edgesIgnoringSafeArea([.horizontal, .bottom])
    }
}
