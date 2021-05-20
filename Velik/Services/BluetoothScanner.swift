//
//  BluetoothScanner.swift
//  Velik
//
//  Created by Grigory Avdyushin on 01/05/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import Combine
import Foundation
import CoreBluetooth

protocol Attribute {
    var uuid: CBUUID { get }
}

class BluetoothScanner: NSObject, Service {

    typealias RSSIData = NSNumber
    typealias Payload = (advertisementData: AdvertisementData, RSSI: RSSIData)
    typealias AdvertisementData = [String: Any]

    class Characteristics: Attribute {
        let peripheral: Peripheral
        let service: CBService
        let characteristic: CBCharacteristic

        var uuid: CBUUID { characteristic.uuid }

        init(peripheral: Peripheral, service: CBService, characteristic: CBCharacteristic) {
            self.peripheral = peripheral
            self.service = service
            self.characteristic = characteristic
        }

        func writeValue(_ data: Data) -> AnyPublisher<Characteristics, Error> {
            peripheral.writeValue(data: data, for: characteristic, type: .withResponse)
                .map { characteristics in
                    debugPrint("written", characteristics)
                    return self
                }
                .print()
                .eraseToAnyPublisher()
        }
    }

    class Service: Attribute {
        let peripheral: Peripheral
        let service: CBService

        var uuid: CBUUID { service.uuid }

        init(peripheral: Peripheral, service: CBService) {
            self.peripheral = peripheral
            self.service = service
        }

        func discoverCharacteristics(characteristicUUIDs: [CBUUID]? = nil) -> AnyPublisher<Characteristics, Error> {
            peripheral.discoverCharacteristics(characteristicUUIDs: characteristicUUIDs, for: service)
        }
    }

    class Peripheral: NSObject, CBPeripheralDelegate {

        private let discoverServicesPublisher = PassthroughSubject<Service, Error>()
        private let discoverServices: AnyPublisher<Service, Error>

        private var discoverCharacteristicsPublisher = PassthroughSubject<Characteristics, Error>()
        private let discoverCharacteristics: AnyPublisher<Characteristics, Error>

        private var notifyingPublishers = [CBUUID: PassthroughSubject<CBCharacteristic, Error>]()
        private var updateValuePublishers = [CBUUID: PassthroughSubject<CBCharacteristic, Error>]()

        private var cancellable = Set<AnyCancellable>()

        let peripheral: CBPeripheral
        weak var scanner: BluetoothScanner!

        init(peripheral: CBPeripheral, scanner: BluetoothScanner) {
            self.peripheral = peripheral
            self.scanner = scanner
            self.discoverServices = discoverServicesPublisher.eraseToAnyPublisher()
            self.discoverCharacteristics = discoverCharacteristicsPublisher.eraseToAnyPublisher()
            super.init()
            peripheral.delegate = self
        }

        func connect() -> Future<Peripheral, Error> {
            scanner.connect(to: peripheral)
        }

        func discoverServices(serviceUUIDs: [CBUUID]? = nil) -> AnyPublisher<Service, Error> {
            peripheral.discoverServices(serviceUUIDs)
            return discoverServicesPublisher.eraseToAnyPublisher()
        }

        func discoverCharacteristics(characteristicUUIDs: [CBUUID]? = nil,
                                     for service: CBService) -> AnyPublisher<Characteristics, Error> {
            discoverCharacteristicsPublisher = PassthroughSubject<Characteristics, Error>()
            peripheral.discoverCharacteristics(characteristicUUIDs, for: service)
            return discoverCharacteristicsPublisher.eraseToAnyPublisher()
        }

        func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
            guard error == nil else {
                discoverServicesPublisher.send(completion: .failure(error!))
                return
            }

            peripheral.services?.forEach {
                // debugPrint("s", $0.uuid.uuidString)
                discoverServicesPublisher.send(Service(peripheral: self, service: $0))
            }
            discoverServicesPublisher.send(completion: .finished)
        }

        func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
            guard error == nil else {
                discoverCharacteristicsPublisher.send(completion: .failure(error!))
                return
            }

            service.characteristics?.forEach {
                // debugPrint("s", service.uuid.uuidString, "c", $0.uuid.uuidString)
                discoverCharacteristicsPublisher.send(
                    Characteristics(peripheral: self, service: service, characteristic: $0)
                )
            }
        }

        func writeValue(data: Data,
                        for characteristic: CBCharacteristic,
                        type: CBCharacteristicWriteType) -> Future<CBCharacteristic, Error> {
            Future<CBCharacteristic, Error> { [unowned self] promise in

                func doWrite() {
                    self.updateValuePublishers[characteristic.uuid] = PassthroughSubject<CBCharacteristic, Error>()
                    self.updateValuePublishers[characteristic.uuid]?
                        .retry(3)
                        .sink(receiveCompletion: { completion in
                            switch completion {
                            case let .failure(error):
                                promise(.failure(error))
                            case .finished:
                                ()
                            }
                        }, receiveValue: { characteristic in
                            promise(.success(characteristic))
                        })
                        .store(in: &self.cancellable)
                    self.peripheral.writeValue(data, for: characteristic, type: type)
                }

                if characteristic.properties.contains(.notify), characteristic.isNotifying == false {
                    self.notifyingPublishers[characteristic.uuid] = PassthroughSubject<CBCharacteristic, Error>()
                    self.notifyingPublishers[characteristic.uuid]?
                        .retry(3)
                        .sink(receiveCompletion: { _ in}, receiveValue: { _ in doWrite() })
                        .store(in: &self.cancellable)
                    self.peripheral.setNotifyValue(true, for: characteristic)
                } else {
                    doWrite()
                }
            }
        }

        func peripheral(_ peripheral: CBPeripheral,
                        didUpdateNotificationStateFor characteristic: CBCharacteristic,
                        error: Error?) {
            debugPrint(#function)
            guard error == nil else {
                notifyingPublishers[characteristic.uuid]?.send(completion: .failure(error!))
                // notifyingPublishers[characteristic.uuid] = nil
                return
            }
            notifyingPublishers[characteristic.uuid]?.send(characteristic)
        }

        func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
            debugPrint(#function)
            guard error == nil else {
                updateValuePublishers[characteristic.uuid]?.send(completion: .failure(error!))
                return
            }
            updateValuePublishers[characteristic.uuid]?.send(characteristic)
        }
    }

    let shouldAutostart = false

    let queue = DispatchQueue(label: String(describing: BluetoothScanner.self), qos: .utility)

    private lazy var manager = CBCentralManager(delegate: self, queue: queue)
    private var listQueue = DispatchQueue(label: String(describing: BluetoothScanner.self), qos: .utility)

    private var discoveredPublisher = PassthroughSubject<Peripheral, Error>()
    private(set) var discovered: AnyPublisher<Peripheral, Error>

    private var connected = [UUID: CBPeripheral]()

    private(set) var connectedPublishers = [UUID: PassthroughSubject<CBPeripheral, Error>]()
    private var cancellable = Set<AnyCancellable>()

    private(set) lazy var state = CurrentValueSubject<CBManagerState, Never>(manager.state)
    private var statePublisher: AnyCancellable?

    override init() {
        discovered = discoveredPublisher.eraseToAnyPublisher()
        super.init()
        state
            .print()
            .sink { [unowned self] state in
                debugPrint("State -> \(state.rawValue)")
                if state == .poweredOff {
                    self.stop()
                }
            }
            .store(in: &cancellable)
    }

    func start() {
        debugPrint("Starting \(Self.self)...")
        guard manager.isScanning == false else {
            debugPrint("You can start only powered on bluetooth and if not already in scanning state")
            return
        }

        func scan() {
            debugPrint("Scanning...")
            manager.scanForPeripherals(
                withServices: nil,
                options: [CBCentralManagerScanOptionAllowDuplicatesKey: true]
            )
        }

        statePublisher = state
            .eraseToAnyPublisher()
            .filter { $0 == .poweredOn }
            .sink { _ in scan() }
    }

    func stop() {
        debugPrint("Stopping \(Self.self)...")
        manager.stopScan()
        statePublisher?.cancel()
        statePublisher = nil
    }

    func connect(to peripheral: CBPeripheral) -> Future<Peripheral, Error> {
        connectedPublishers[peripheral.identifier] = PassthroughSubject<CBPeripheral, Error>()

        return Future<Peripheral, Error> { [unowned self] promise in
            self.connectedPublishers[peripheral.identifier]!.sink(receiveCompletion: { completion in
                switch completion {
                case let .failure(error):
                    promise(.failure(error))
                case .finished:
                    ()
                }
            }, receiveValue: { value in
                promise(.success(Peripheral(peripheral: value, scanner: self)))
            }).store(in: &self.cancellable)

            self.listQueue.sync {
                self.connected[peripheral.identifier] = peripheral
            }
            self.manager.connect(peripheral, options: nil)
        }
    }

    func disconnect(peripheral: CBPeripheral) {
        manager.cancelPeripheralConnection(peripheral)
    }
}

extension BluetoothScanner: CBCentralManagerDelegate {

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        state.send(central.state)
    }

    func centralManager(_ central: CBCentralManager,
                        didDiscover peripheral: CBPeripheral,
                        advertisementData: [String: Any], rssi RSSI: NSNumber) {
        discoveredPublisher.send(Peripheral(peripheral: peripheral, scanner: self))
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        connectedPublishers[peripheral.identifier]?.send(peripheral)
        connectedPublishers[peripheral.identifier]?.send(completion: .finished)
    }

    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        guard error == nil else {
            connectedPublishers[peripheral.identifier]?.send(completion: .failure(error!))
            return
        }
        connectedPublishers[peripheral.identifier]?.send(completion: .finished)
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        listQueue.sync {
            connected[peripheral.identifier] = nil
        }
    }
}
