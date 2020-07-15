//
//  Service.swift
//  Velik
//
//  Created by Grigory Avdyushin on 01/05/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

protocol Service {

    var shouldAutostart: Bool { get }

    func start()
    func stop()
}
