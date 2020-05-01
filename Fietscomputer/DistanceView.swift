//
//  DistanceView.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 01/05/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import SwiftUI
import Combine

extension Formatters {

    static var distanceFormatter: MeasurementFormatter = {
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .medium
        formatter.unitOptions = [.providedUnit]
        formatter.numberFormatter.maximumFractionDigits = 1
        formatter.numberFormatter.minimumFractionDigits = 1
        return formatter
    }()
}

class DistanceViewModel: ObservableObject {

    @Published var distance = "0"

    @Injected private var service: LocationService
    private var cancellables = Set<AnyCancellable>()

    init() {
        service.distance
            .sink { value in
                let km = Measurement(value: value, unit: UnitLength.meters).converted(to: .kilometers)
                self.distance = Formatters.distanceFormatter.string(from: km)
            }
            .store(in: &cancellables)
    }

}
struct DistanceView: View {

    @ObservedObject var viewModel: DistanceViewModel

    var body: some View {
        Text(viewModel.distance)
            .font(.custom("DIN Alternate", size: 30))
    }
}
