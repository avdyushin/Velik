//
//  RideFullSummaryView.swift
//  Velik
//
//  Created by Grigory Avdyushin on 20/06/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import SwiftUI

struct RideFullSummaryView: View {
    var viewModel: RideViewModel
    var body: some View {
        HStack {
            Spacer()
            VStack(spacing: 8) {
                ValueDescriptionView(text: viewModel.duration, details: viewModel.durationLabel)
                ValueDescriptionView(text: viewModel.avgSpeed, details: viewModel.avgSpeedLabel)
                ValueDescriptionView(text: viewModel.elevationGain, details: viewModel.elevGainLabel)
                ValueDescriptionView(text: viewModel.energy, details: viewModel.energyLabel)
            }
            Spacer()
            VStack(spacing: 8) {
                ValueDescriptionView(text: viewModel.distance, details: viewModel.distanceLabel)
                ValueDescriptionView(text: viewModel.maxSpeed, details: viewModel.maxSpeedLabel)
                ValueDescriptionView(text: viewModel.power, details: viewModel.powerLabel)
                ValueDescriptionView(text: viewModel.weightLoss, details: viewModel.weightLossLabel)
            }
            Spacer()
        }
    }
}
