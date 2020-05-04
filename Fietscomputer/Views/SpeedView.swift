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

class SpeedViewModel: GaugeViewModel {

    override init() {
        super.init()

        fontSize = 100
        locationService.speed
            .map { $0 < 0 ? 0 : $0 } // filter out negative values
            .sink { value in // m/s
                let mps = Measurement(value: value, unit: UnitSpeed.metersPerSecond)
                let kph = mps.converted(to: UnitSpeed.kilometersPerHour)
                let formatted = Formatters.formatted(from: kph)
                self.value = formatted.value
                self.units = formatted.units.uppercased()
            }
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

struct ContentView_Previews: PreviewProvider {

    static var previews: some View {
        SpeedView(viewModel: SpeedViewModel())
    }
}
