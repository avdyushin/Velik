//
//  AsyncMapImage.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 19/06/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import SwiftUI
import struct CoreLocation.CLLocationCoordinate2D

struct AsyncMapImage<Placeholder: View>: View {

    @ObservedObject private var mapLoader: MapImageLoader
    private let placeholder: Placeholder

    init(center: CLLocationCoordinate2D, @ViewBuilder _ placeholder: () -> Placeholder) {
        self.mapLoader = MapImageLoader(center: center)
        self.placeholder = placeholder()
    }

    var body: some View {
        Group {
            if mapLoader.mapImage != nil {
                Image(uiImage: mapLoader.mapImage!)
                    .resizable()
                    .frame(width: 120, height: 80, alignment: .leading)
            } else {
                placeholder
            }
        }
        .onAppear(perform: mapLoader.start)
        .onDisappear(perform: mapLoader.stop)
    }
}
