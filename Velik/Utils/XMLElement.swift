//
//  XMLElement.swift
//  Velik
//
//  Created by Grigory Avdyushin on 02/07/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import Foundation

final class XMLElement: XMLNode {
    let name: String
    var attributes = [String: String]()
    var children = [XMLNode]()
    var value: String?

    init(_ name: String, attributes: [String: String] = [:], value: String? = nil) {
        self.name = name
        self.attributes = attributes
        self.value = value
    }
}
