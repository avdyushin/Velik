//
//  SpeedView.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 30/04/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import SwiftUI
import Combine

struct SpeedView: View {

    @ObservedObject var viewModel: SpeedViewModel

    init(viewModel: SpeedViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            GaugeView(viewModel: viewModel)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            HStack {
                Text(viewModel.units)
                    .foregroundColor(.secondary)
                    .font(.caption).bold()
                    .padding(4)
                    .cornerRadius(8)
            }.fixedSize()
        }
        .padding(18)
    }
}
