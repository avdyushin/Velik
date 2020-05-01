//
//  SpeedView.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 30/04/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import SwiftUI
import Combine

struct Formatters {
    static var speedMeasurement: MeasurementFormatter = {
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .short
        formatter.unitOptions = .providedUnit
        formatter.numberFormatter.maximumFractionDigits = 1
        formatter.numberFormatter.minimumFractionDigits = 1
        return formatter
    }()

    static var speedValue: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        formatter.minimumFractionDigits = 1
        return formatter
    }()

    static func formatted<U: Unit>(from measurement: Measurement<U>) -> (value: String, units: String) {
        let value = Formatters.speedValue.string(from: NSNumber(value: measurement.value))
        let units = Formatters.speedMeasurement.string(from: measurement.unit)
        return (value ?? "0.0", units)
    }
}

class SpeedViewModel: ObservableObject {

    @Published var speedText = "0.0"
    @Published var speedUnit = ""

    @Injected private var service: LocationService
    private var cancellables = Set<AnyCancellable>()

    init() {
        service.speed
            .map { $0 < 0 ? 0 : $0 } // filter out negative values
            .sink { value in
                // m/s
                let mps = Measurement(value: value, unit: UnitSpeed.metersPerSecond)
                debugPrint(mps)
                let kph = mps.converted(to: UnitSpeed.kilometersPerHour)
                let formatted = Formatters.formatted(from: kph)
                self.speedText = formatted.value
                self.speedUnit = formatted.units.uppercased()
//                return Formatters.speedMeasurement.string(from: kph)
            }
//            .replaceError(with: speedText)
//            .assign(to: \.speedText, on: self)
            .store(in: &cancellables)
    }
}

struct SpeedView: View {

    @ObservedObject var viewModel: SpeedViewModel

    init(viewModel: SpeedViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Text(viewModel.speedText)
                .font(.custom("DIN Alternate", size: 100))
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            HStack {
                Text(viewModel.speedUnit)
                    .font(.caption).bold()
                    .background(Color.white)
                    .padding(4)
                    .cornerRadius(8)
            }.fixedSize()
        }
        .padding(18)
    }
}

struct ContentView_Previews: PreviewProvider {

    static var previews: some View {
        SpeedView(viewModel: SpeedViewModel())
    }
}
