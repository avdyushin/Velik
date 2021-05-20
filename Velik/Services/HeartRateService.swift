//
//  HeartRateService.swift
//  Velik
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

    let shouldAutostart = false

    private let scanner = BluetoothScanner()
    private var cancellable = Set<AnyCancellable>()
    private var authCh = PassthroughSubject<BluetoothScanner.Characteristics, Error>()
    private var ready = CurrentValueSubject<Bool, Error>(false)
    private var heartRateCh = PassthroughSubject<BluetoothScanner.Characteristics, Error>()
    private let key: [UInt8] = [
        0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39, 0x40, 0x41, 0x42, 0x43, 0x44, 0x45
    ]

    func start() {
        scanner.start()
        bindDiscovered()
    }

    func stop() {
        scanner.stop()
    }

    fileprivate func bindDiscovered() {
        scanner
            .discovered
            .filter { $0.peripheral.name?.hasPrefix("MI") == true }
            .print()
            .flatMap { $0.connect() }
            .retry(3)
            .flatMap { $0.discoverServices() }
            .retry(3)
            .flatMap { $0.discoverCharacteristics() }
            .retry(3)
            .sink(receiveCompletion: { _ in },
                  receiveValue: { [authCh, heartRateCh] in
                    switch $0.uuid {
                    case CBUUID(string: "00000009-0000-3512-2118-0009AF100700"):
                        authCh.send($0)
                    case CBUUID(string: "2A06"):
                        heartRateCh.send($0)
                    default: ()
                    }
            })
            .store(in: &cancellable)
    }

    fileprivate func bindAuth() {
        authCh
            .flatMap { $0.writeValue(Data([0x02, 0x08])) }
            .filter { $0.characteristic.value?.prefix(3) == Data([0x10, 0x02, 0x01]) }
            .tryMap { [key] (characteristic: BluetoothScanner.Characteristics) ->
                AnyPublisher<BluetoothScanner.Characteristics, Error> in
                guard let value = characteristic.characteristic.value else {
                    throw HRError.auth
                }

                guard let enc = AES(key: Data(key)).encrypt(data: value.dropFirst(3)) else {
                    throw HRError.auth
                }
                return characteristic.writeValue(Data([0x03, 0x08]) + enc).eraseToAnyPublisher()
        }
        .switchToLatest()
        .filter { $0.characteristic.value?.prefix(3) == Data([0x10, 0x03, 0x01]) }
        .sink(receiveCompletion: { _ in },
              receiveValue: { [ready] _ in ready.send(true) })
            .store(in: &cancellable)
    }

    fileprivate func bindHeartRate() {
        Publishers.CombineLatest(heartRateCh, ready)
            .filter { $0.1 == true }
            .flatMap { heartRate, _ in
                heartRate.writeValue(Data([0x01]))
        }
        .sink(receiveCompletion: { _ in },
              receiveValue: { _ in })
            .store(in: &cancellable)
    }
}
