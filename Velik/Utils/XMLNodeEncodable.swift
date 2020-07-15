//
//  XMLNodeEncodable.swift
//  Velik
//
//  Created by Grigory Avdyushin on 02/07/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import Foundation

protocol XMLNodeEncodable {
    static func nodeEncoding(forKey key: CodingKey) -> XMLEncoder.NodeEncodingStrategy
}

extension Optional where Wrapped == XMLNodeEncodable {
    func encoding(forKey key: CodingKey) -> XMLEncoder.NodeEncodingStrategy {
        switch self {
        case .some(let object):
            return type(of: object).nodeEncoding(forKey: key)
        default:
            return .element
        }
    }
}
