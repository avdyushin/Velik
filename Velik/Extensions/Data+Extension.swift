//
//  Data+Extension.swift
//  Velik
//
//  Created by Grigory Avdyushin on 04/05/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import Foundation

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
            .map { index, byte in String(format: "%02x%@", byte, [3, 5, 7, 9].contains(index) ? "-" : "") }
            .joined()
    }
}
