//
//  AsyncMapImage.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 19/06/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import SwiftUI
import struct UIKit.CGSize
import struct CoreLocation.CLLocationCoordinate2D

struct AsyncMapImage<Placeholder: View>: View {

    @ObservedObject private var mapLoader: MapImageLoader
    private let placeholder: Placeholder

    init(center: CLLocationCoordinate2D,
         processor: MapSnapshotProcessor,
         @ViewBuilder _ placeholder: () -> Placeholder) {

        self.mapLoader = MapImageLoader(center: center, processor: processor)
        self.placeholder = placeholder()
    }

    var body: some View {
        Group {
            if mapLoader.mapImage != nil {
                Image(uiImage: mapLoader.mapImage!)
                    .resizable()
            } else {
                placeholder
            }
        }
        .onAppear(perform: mapLoader.start)
        //.onDisappear(perform: mapLoader.stop)
    }
}
