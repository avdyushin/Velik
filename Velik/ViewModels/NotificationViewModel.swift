//
//  NotificationViewModel.swift
//  Velik
//
//  Created by Grigory Avdyushin on 11/06/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import SwiftUI

class NotificationViewModel: ViewModel, ObservableObject {

    @Published var message = ""
    @Published var showNotification = false

    override init() {
        super.init()

        rideService.state
            .sink {
                switch $0 {
                case .idle:
                    ()
                case .paused:
                    self.show(message: "Ride has been paused")
                case .running:
                    self.show(message: "Ride has been started")
                case .stopped:
                    self.show(message: "Ride has been stopped")
                }
        }
        .store(in: &cancellable)
    }

    func show(message: String) {
        self.message = message
        withAnimation {
            self.showNotification = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation {
                self.showNotification = false
            }
        }
    }
}
