//
//  HeartRateService.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 04/05/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import Combine
import Foundation
import CoreBluetooth

class HeartRateService: Service {

    let scanner = BluetoothScanner()
    var active: CBPeripheral?

    var cancellables = Set<AnyCancellable>()

    func start() {
        debugPrint("Will start")
        scanner.start()
        scanner.connectedList
            .removeDuplicates()
            .print()
            .filter { $0.isEmpty == false }
            .compactMap { $0.first }
            .assign(to: \.active, on: self)
            .store(in: &cancellables)
    }

    func stop() {
        scanner.stop()
    }
}
