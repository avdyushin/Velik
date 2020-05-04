//
//  BluetoothScanner.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 01/05/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import Combine
import Foundation
import CoreBluetooth

class BluetoothScanner: NSObject, Service {

    typealias RSSIData = NSNumber
    typealias Payload = (advertisementData: AdvertisementData, RSSI: RSSIData)
    typealias AdvertisementData = [String: Any]

    private let queue = DispatchQueue(label: String(describing: BluetoothScanner.self), qos: .utility)
    private lazy var manager = CBCentralManager(delegate: self, queue: queue)
    private var listQueue = DispatchQueue(label: String(describing: BluetoothScanner.self), qos: .utility)
    private var connectedPublisher = CurrentValueSubject<[CBPeripheral], Never>([])
    var connectedList: AnyPublisher<[CBPeripheral], Never>
    private var connected = [UUID:CBPeripheral]()

    override init() {
        connectedList = connectedPublisher.eraseToAnyPublisher()
    }

    func start() {
        debugPrint("Started \(Self.self)")
        guard manager.state == .poweredOn, manager.isScanning == false else {
            debugPrint("You can start only powered on bluetooth and if not already in scanning state")
            return
        }

//        let hrService = CBUUID(string: "180D")
        manager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
    }

    func stop() {
        manager.stopScan()
    }
}

extension BluetoothScanner: CBCentralManagerDelegate{

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        debugPrint("State -> \(central.state.rawValue)")
        switch central.state {
        case .poweredOn:
            debugPrint("Starting...")
            start()
        case .poweredOff:
            debugPrint("Stopping...")
            stop()
        default:
            debugPrint("Not handled state")
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        guard let name = peripheral.name else {
            return
        }

        guard name.hasPrefix("MI") else {
            return
        }

        if !connected.keys.contains(peripheral.identifier) {
            debugPrint("connecting to \(name)...")
            connected[peripheral.identifier] = peripheral
            central.connect(peripheral, options: nil)
        }
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        connectedPublisher.send(Array(connected.values))
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }

    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        debugPrint("Can't connect to \(peripheral)")
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        debugPrint("Disconnected \(peripheral)")
        listQueue.sync {
            connected[peripheral.identifier] = nil
        }
        connectedPublisher.send(Array(connected.values))
        central.connect(peripheral, options: nil)
    }

//    func centralManager(_ central: CBCentralManager, willRestoreState dict: [String: Any]) {
//        // Get list of peripherals we were connected to or was trying to connect to before app was terminated
//        guard let peripherals = dict[CBCentralManagerRestoredStatePeripheralsKey] as? [CBPeripheral] else {
//            return
//        }
//        debugPrint("Restore \(peripherals)")
//    }
}

extension BluetoothScanner: CBPeripheralDelegate {

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        peripheral.services?.forEach {
            peripheral.discoverCharacteristics(nil, for: $0)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        service.characteristics?.forEach { ch in
            if ch.uuid == CBUUID(string: "2A37") {
                debugPrint("Monitor HR found")
            }
            if ch.uuid == CBUUID(string: "2A39") {
                debugPrint("Control HR found")
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print("New value for: \(characteristic) e: \(error)")
        guard let value = characteristic.value else {
            return
        }
        debugPrint("value = \(value.hexString)")

        if characteristic.uuid == CBUUID(string: "2A37") {
            debugPrint("Heart Rate: \(String(format: "%d", value[1])) BPM")
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
    }

    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
    }
}
