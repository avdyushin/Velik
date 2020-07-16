//
//  InputProcessor.swift
//  Velik
//
//  Created by Grigory Avdyushin on 16/07/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import Foundation

protocol InputProcessor {
    associatedtype Input
    associatedtype Output
    func process(input: Input) -> Output
}
