//
//  DurationView.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 01/05/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import SwiftUI
import Combine

extension Formatters {

    static var elaspedFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = [.pad]
        return formatter
    }()
}

class DurationViewModel: ObservableObject {

    @Published var elapsedTime = "00:00:00"

    @Injected private var service: RideService
    private var cancellables = Set<AnyCancellable>()

    init() {
        service.elapsed.sink { value in
            self.elapsedTime = Formatters.elaspedFormatter.string(from: value)!
        }.store(in: &cancellables)
    }
}

struct DurationView: View {

    @ObservedObject var viewModel: DurationViewModel

    var body: some View {
        Text(viewModel.elapsedTime)
    }
}
