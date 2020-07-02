//
//  XMLEncoder.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 01/07/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import Foundation

protocol XMLNodeEncodable {
    static func nodeEncoding(forKey key: CodingKey) -> XMLEncoder.NodeEncoding
}

extension Optional where Wrapped == XMLNodeEncodable {
    func encoding(forKey key: CodingKey) -> XMLEncoder.NodeEncoding {
        switch self {
        case .some(let object):
            return type(of: object).nodeEncoding(forKey: key)
        default:
            return .element
        }
    }
}

class XMLEncoder: Encoder {

    enum NodeEncoding {
        case attribute
        case element
    }

    var codingPath: [CodingKey] = []
    var userInfo: [CodingUserInfoKey: Any] = [:]
    var node: XMLElement
    var nodeEncodable: XMLNodeEncodable?

    init(node: XMLElement, nodeEncodable: XMLNodeEncodable?) {
        self.node = node
        self.nodeEncodable = nodeEncodable
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
            let child = XMLElement(key.stringValue)
            child.value = value
            node.children.append(child)
        }

        mutating func encode(_ value: Double, forKey key: Key) throws {
            debugPrint("node encode", key.stringValue, "with", nodeEncodable.encoding(forKey: key))
            let encodedValue = "\(value)"
            switch nodeEncodable.encoding(forKey: key) {
            case .attribute:
                node.attributes[key.stringValue] = encodedValue
            case .element:
                let child = XMLElement(key.stringValue)
                child.value = encodedValue
                node.children.append(child)
            }
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
            let child = XMLElement(key.stringValue)
            node.children.append(child)
            try value.encode(to: XMLEncoder(node: child, nodeEncodable: value as? XMLNodeEncodable))
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

    struct UEC: UnkeyedEncodingContainer {

        var codingPath: [CodingKey] = []
        var count: Int = 0
        var node: XMLElement

        init(node: XMLElement) {
            self.node = node
        }

        mutating func encodeNil() throws { fatalError() }
        mutating func encode(_ value: String) throws { fatalError() }
        mutating func encode(_ value: Double) throws { fatalError() }
        mutating func encode(_ value: Float) throws { fatalError() }
        mutating func encode(_ value: Int) throws { fatalError() }
        mutating func encode(_ value: Int8) throws { fatalError() }
        mutating func encode(_ value: Int16) throws { fatalError() }
        mutating func encode(_ value: Int32) throws { fatalError() }
        mutating func encode(_ value: Int64) throws { fatalError() }
        mutating func encode(_ value: UInt) throws { fatalError() }
        mutating func encode(_ value: UInt8) throws { fatalError() }
        mutating func encode(_ value: UInt16) throws { fatalError() }
        mutating func encode(_ value: UInt32) throws { fatalError() }
        mutating func encode(_ value: UInt64) throws { fatalError() }
        mutating func encode<T>(_ value: T) throws where T: Encodable {
            try value.encode(to: XMLEncoder(node: node, nodeEncodable: value as? XMLNodeEncodable))
        }
        mutating func encode(_ value: Bool) throws { fatalError() }
        mutating func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type) -> KeyedEncodingContainer<NestedKey>
            where NestedKey: CodingKey { fatalError() }
        mutating func nestedUnkeyedContainer() -> UnkeyedEncodingContainer { fatalError() }
        mutating func superEncoder() -> Encoder { fatalError() }
    }

    func unkeyedContainer() -> UnkeyedEncodingContainer {
        UEC(node: (node.children.last as? XMLElement) ?? node)
    }

    struct SVEC: SingleValueEncodingContainer {
        var codingPath: [CodingKey] = []
        var node: XMLElement

        init(node: XMLElement) {
            self.node = node
        }

        mutating func encodeNil() throws { }

        mutating func encode(_ value: Bool) throws { fatalError() }

        mutating func encode(_ value: String) throws {
            node.value = value
        }

        mutating func encode(_ value: Double) throws {
            node.value = "\(value)"
        }

        mutating func encode(_ value: Float) throws { fatalError() }
        mutating func encode(_ value: Int) throws { fatalError() }
        mutating func encode(_ value: Int8) throws { fatalError() }
        mutating func encode(_ value: Int16) throws { fatalError() }
        mutating func encode(_ value: Int32) throws { fatalError() }
        mutating func encode(_ value: Int64) throws { fatalError() }
        mutating func encode(_ value: UInt) throws { fatalError() }
        mutating func encode(_ value: UInt8) throws { fatalError() }
        mutating func encode(_ value: UInt16) throws { fatalError() }
        mutating func encode(_ value: UInt32) throws { fatalError() }
        mutating func encode(_ value: UInt64) throws { fatalError() }

        mutating func encode<T>(_ value: T) throws where T: Encodable {
            try value.encode(to: XMLEncoder(node: node, nodeEncodable: value as? XMLNodeEncodable))
        }
    }

    func singleValueContainer() -> SingleValueEncodingContainer {
        SVEC(node: node)
    }
}
