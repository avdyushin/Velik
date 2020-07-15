//
//  SpeedView.swift
//  Velik
//
//  Created by Grigory Avdyushin on 30/04/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import SwiftUI
import Combine

struct SpeedView: View {

    @ObservedObject var viewModel: GaugeViewModel

    init(viewModel: GaugeViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ZStack(alignment: .top) {
            GaugeView(viewModel: viewModel)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            HStack {
                if !viewModel.title.isEmpty {
                    Text(viewModel.title)
                        .foregroundColor(.secondary)
                        .font(.caption).bold()
                        .padding(4)
                        .cornerRadius(8)
                }
                Spacer()
                if !viewModel.units.isEmpty {
                    Text(viewModel.units)
                        .foregroundColor(.secondary)
                        .font(.caption).bold()
                        .padding(4)
                        .cornerRadius(8)
                }
            }
        }
        .padding(18)
    }
}
