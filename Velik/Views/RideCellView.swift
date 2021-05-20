//
//  RideCellView.swift
//  Velik
//
//  Created by Grigory Avdyushin on 19/06/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import SwiftUI
import CoreLocation

struct RideCellView: View {

    var viewModel: RideViewModel

    var body: some View {
        VStack {
            HStack(alignment: .firstTextBaseline) {
                Text(viewModel.title)
                    .lineLimit(3)
                Spacer()
                Text(viewModel.date)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            HStack(alignment: .top) {
                RideMapSnapshotView(viewModel: viewModel, mapSize: viewModel.mapSize)
                    .frame(width: 120, height: 80, alignment: .leading)
                RideSummaryView(viewModel: viewModel)
                    .frame(minWidth: 0, maxWidth: .infinity)
            }
        }
    }
}
