//
//  HeartRateService.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 04/05/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import Combine
import Foundation
import CommonCrypto
import CoreBluetooth

class HeartRateService: Service {

    enum HRError: Error { case auth }

    private let scanner = BluetoothScanner()
    private var cancellables = Set<AnyCancellable>()
    private var auth = PassthroughSubject<BluetoothScanner.Characteristics, Error>()
    private var ready = CurrentValueSubject<Bool, Error>(false)
    private var hr = PassthroughSubject<BluetoothScanner.Characteristics, Error>()
    private let key: [UInt8] = [0x30,0x31,0x32,0x33,0x34,0x35,0x36,0x37,0x38,0x39,0x40,0x41,0x42,0x43,0x44,0x45]

    func start() {

        scanner.start()

        scanner
            .discovered
            .filter { $0.peripheral.name?.hasPrefix("MI") == true }
            .first { $0.peripheral.identifier == UUID(uuidString: "12199EBB-F68D-4B30-90D8-AC3374BA150D")! }
            .flatMap { $0.connect() }
            .retry(3)
            .flatMap { $0.discoverServices() }
            .retry(3)
            //.filter { $0.uuid == CBUUID(string: "FEE1") }
            .flatMap { $0.discoverCharacteristics() }
            .retry(3)
//            .filter { $0.uuid == CBUUID(string: "00000009-0000-3512-2118-0009AF100700") }
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [auth, hr] in
                    switch $0.uuid {
                    case CBUUID(string: "00000009-0000-3512-2118-0009AF100700"):
                        auth.send($0)
                    case CBUUID(string: "2A06"):
                        hr.send($0)
                    default: ()
                    }
            })
            .store(in: &cancellables)

        auth
            .flatMap { $0.writeValue(Data([0x02, 0x08])) }
            .filter { $0.characteristic.value?.prefix(3) == Data([0x10, 0x02, 0x01]) }
            .tryMap { [key] (c: BluetoothScanner.Characteristics) -> AnyPublisher<BluetoothScanner.Characteristics, Error> in
                guard let value = c.characteristic.value else {
                    throw HRError.auth
                }

                guard let enc = AES(key: Data(key)).encrypt(data: value.dropFirst(3)) else {
                    throw HRError.auth
                }
                return c.writeValue(Data([0x03, 0x08]) + enc).eraseToAnyPublisher()
            }
            .switchToLatest()
            .filter { $0.characteristic.value?.prefix(3) == Data([0x10, 0x03, 0x01]) }
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [ready] _ in ready.send(true) })
            .store(in: &cancellables)

        Publishers.CombineLatest(hr, ready)
            .filter { $0.1 == true }
            .flatMap { (h, r) in
                h.writeValue(Data([0x01]))
            }
            .sink(receiveCompletion: { _ in },
                  receiveValue: { _ in })
            .store(in: &cancellables)
    }

    func stop() {
        scanner.stop()
    }
}
