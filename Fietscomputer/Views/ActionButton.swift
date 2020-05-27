//
//  ActionButton.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 27/05/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import SwiftUI

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
