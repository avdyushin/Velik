//
//  GPXTrack.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 02/07/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import Foundation

struct GPXTrack {
    let id: UUID
    let name: String?
    let timestamp: Date
    let points: [GPXPoint]
}
