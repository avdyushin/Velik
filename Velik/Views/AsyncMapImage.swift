//
//  AsyncMapImage.swift
//  Velik
//
//  Created by Grigory Avdyushin on 19/06/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import SwiftUI
import MapKit
import struct UIKit.CGSize

struct AsyncMapImage<Placeholder: View>: View {

    @ObservedObject private var mapLoader: MapImageLoader
    private let placeholder: Placeholder

    init(uuid: UUID,
         region: MKCoordinateRegion,
         size: CGSize,
         processor: MapSnapshotProcessor,
         @ViewBuilder _ placeholder: () -> Placeholder) {

        self.mapLoader = MapImageLoader(uuid: uuid, region: region, size: size, processor: processor)
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
        .onDisappear(perform: mapLoader.stop)
    }
}
