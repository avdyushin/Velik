//
//  Array+Extension.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 04/05/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import Foundation

extension Array {
    func chunked(size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0+size, count)])
        }
    }
}
