//
//  XMLEncoder.swift
//  Velik
//
//  Created by Grigory Avdyushin on 01/07/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import Foundation

class XMLEncoder: Encoder {

    enum NodeEncodingStrategy {
        case attribute
        case element
    }

    var codingPath: [CodingKey] = []
    var userInfo: [CodingUserInfoKey: Any] = [:]

    private var node: XMLElement
    private var nodeEncodable: XMLNodeEncodable?

    private init(node: XMLElement, nodeEncodable: XMLNodeEncodable?) {
        self.node = node
        self.nodeEncodable = nodeEncodable
    }

    static func encode(_ encodable: Encodable & XMLNodeEncodable, root: String) throws -> XMLElement {
        let encoder = XMLEncoder(node: XMLElement(root), nodeEncodable: encodable)
        try encodable.encode(to: encoder)
        return encoder.node
    }

    struct KEC<Key: CodingKey>: KeyedEncodingContainerProtocol {

        var codingPath: [CodingKey] = []
        var node: XMLElement
        var nodeEncodable: XMLNodeEncodable?

        init(node: XMLElement, nodeEncodable: XMLNodeEncodable?) {
            self.node = node
            self.nodeEncodable = nodeEncodable
        }

        mutating func encodeNil(forKey key: Key) throws { fatalError() }
        mutating func encode(_ value: Bool, forKey key: Key) throws { fatalError() }

        mutating func encode(_ value: String, forKey key: Key) throws {
            switch nodeEncodable.encoding(forKey: key) {
            case .attribute:
                node.attributes[key.stringValue] = value
            case .element:
                let child = XMLElement(key.stringValue)
                child.value = value
                node.children.append(child)
            }
        }

        mutating func encode(_ value: Double, forKey key: Key) throws {
            try encode("\(value)", forKey: key)
        }

        mutating func encode(_ value: Float, forKey key: Key) throws { fatalError() }
        mutating func encode(_ value: Int, forKey key: Key) throws { fatalError() }
        mutating func encode(_ value: Int8, forKey key: Key) throws { fatalError() }
        mutating func encode(_ value: Int16, forKey key: Key) throws { fatalError() }
        mutating func encode(_ value: Int32, forKey key: Key) throws { fatalError() }
        mutating func encode(_ value: Int64, forKey key: Key) throws { fatalError() }
        mutating func encode(_ value: UInt, forKey key: Key) throws { fatalError() }
        mutating func encode(_ value: UInt8, forKey key: Key) throws { fatalError() }
        mutating func encode(_ value: UInt16, forKey key: Key) throws { fatalError() }
        mutating func encode(_ value: UInt32, forKey key: Key) throws { fatalError() }
        mutating func encode(_ value: UInt64, forKey key: Key) throws { fatalError() }

        mutating func encode<T>(_ value: T, forKey key: Key) throws where T: Encodable {
            switch value {
            case let date as Date:
                let child = XMLElement(key.stringValue)
                child.value = DateFormatter.iso8601.string(from: date)
                node.children.append(child)
            default:
                let child = XMLElement(key.stringValue)
                node.children.append(child)
                try value.encode(to: XMLEncoder(node: child, nodeEncodable: value as? XMLNodeEncodable))
            }
        }

        mutating func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type,
                                                 forKey key: Key) -> KeyedEncodingContainer<NestedKey>
            where NestedKey: CodingKey {
                let child = XMLElement(key.stringValue)
                node.children.append(child)
                return KeyedEncodingContainer(KEC<NestedKey>(node: child, nodeEncodable: nodeEncodable))
        }

        mutating func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer { fatalError() }
        mutating func superEncoder() -> Encoder { fatalError() }
        mutating func superEncoder(forKey key: Key) -> Encoder { fatalError() }
    }

    func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key: CodingKey {
        KeyedEncodingContainer(KEC(node: node, nodeEncodable: nodeEncodable))
    }

    func unkeyedContainer() -> UnkeyedEncodingContainer { fatalError() }
    func singleValueContainer() -> SingleValueEncodingContainer { fatalError() }
}
