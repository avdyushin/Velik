//
//  BluetoothService.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 01/05/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import Foundation
import CoreBluetooth

extension Array {
    func chunked(size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0+size, count)])
        }
    }
}

extension Data {
    var hexString: String {
        let string = self
            .map { String(format: "%02x", $0) }
            .chunked(size: 4)
            .map { $0.reduce("") { acc, value in acc.appending(value) }}
            .joined(separator: " ")
        return "<\(string)> length=\(count)"
    }

    var rawHexString: String {
        self.map { String(format: "%02x", $0) }.joined()
    }

    var uuidString: String {
        self.enumerated()
            .map { i, b in String(format: "%02x%@", b, [3, 5, 7, 9].contains(i) ? "-" : "") }
            .joined()
    }
}

protocol BluetoothScanner: Service, CBCentralManagerDelegate {

    typealias RSSIData = NSNumber
    typealias Payload = (advertisementData: AdvertisementData, RSSI: RSSIData)
    typealias AdvertisementData = [String: Any]

}

class HeartRateScanner: NSObject, BluetoothScanner {

    private let queue = DispatchQueue(label: String(describing: HeartRateScanner.self), qos: .utility)
    private lazy var manager = CBCentralManager(delegate: self, queue: queue)
    private var connected: CBPeripheral?

    func start() {
        guard manager.state == .poweredOn, manager.isScanning == false else {
            debugPrint("You can start only powered on bluetooth and if not already in scanning state")
            return
        }

        manager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
    }

    func stop() {
        manager.stopScan()
    }
}

extension HeartRateScanner {

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
//            debugPrint("Skipping unnamed peripheral")
            return
        }

        guard name.hasPrefix("MI") else {
//            debugPrint("Skipping \"\(name)\" service")
            return
        }

        debugPrint("connecting to \(name)")
        if peripheral.state != .connected || peripheral.state != .connecting {
            connected = peripheral
            central.connect(peripheral, options: nil)
        }
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        debugPrint("did connect to \(peripheral)")
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }

    func centralManager(_ central: CBCentralManager, willRestoreState dict: [String: Any]) {
        // Get list of peripherals we were connected to or was trying to connect to before app was terminated
        guard let peripherals = dict[CBCentralManagerRestoredStatePeripheralsKey] as? [CBPeripheral] else {
            return
        }
        debugPrint("Restore \(peripherals)")
    }

    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
    }
}

extension HeartRateScanner: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        peripheral.services?.forEach {
            debugPrint("found \($0)")
            peripheral.discoverCharacteristics(nil, for: $0)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        service.characteristics?.forEach {
            debugPrint("char \($0)")
            peripheral.setNotifyValue(true, for: $0)
            // todo set notify
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print("New value for: \(characteristic)")
        guard let value = characteristic.value else {
            return
        }
        debugPrint("value = \(value.hexString)")

        if characteristic.uuid == CBUUID(string: "2A37") {
            debugPrint("Heart Rate: \(String(format: "%d", value[1])) BPM")
        }
        if let string = String(data: value, encoding: .ascii) {
            debugPrint("Decoded string \(string)")
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        debugPrint("didWrite")
    }

    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        debugPrint("didReadRSSI \(RSSI)")
    }
}
