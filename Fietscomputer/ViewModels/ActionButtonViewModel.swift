//
//  ActionButtonViewModel.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 29/05/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import SwiftUI

class ActionButtonViewModel: ViewModel, ObservableObject {

    let leftTitle = "Stop"
    @Published var rightTitle = "Start"
    @Published var isMultiButton = false

    override init() {
        super.init()

        rideService.state
            .sink {
                switch $0 {
                case .idle, .stopped:
                    self.isMultiButton = false
                    self.rightTitle = "Start"
                case .paused:
                    self.isMultiButton = true
                    self.rightTitle = "Continue"
                case .running:
                    self.isMultiButton = true
                    self.rightTitle = "Pause"
                }
            }
            .store(in: &cancellables)
    }
}
