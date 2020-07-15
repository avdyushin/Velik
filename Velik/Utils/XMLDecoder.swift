//
//  XMLDecoder.swift
//  Velik
//
//  Created by Grigory Avdyushin on 24/06/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import Foundation

class XMLDecoder: Decoder {

    var codingPath: [CodingKey] = []
    var userInfo: [CodingUserInfoKey: Any] = [:]
    let element: XMLNode
    let name: String?

    init(_ element: XMLNode, name: String? = nil) {
        self.element = element
        self.name = name
    }

    static func decode<T: Decodable>(_ xmlString: String) throws -> T {
        guard let root = NanoXML(xmlString: xmlString).root else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(codingPath: [], debugDescription: "No XML root node")
            )
        }
        let decoder = XMLDecoder(root)
        return try T(from: decoder)
    }

    struct KDC<Key: CodingKey>: KeyedDecodingContainerProtocol {
        var codingPath: [CodingKey] = []
        var allKeys: [Key] = []
        let element: XMLNode
        let name: String?

        init(_ element: XMLNode, name: String?) {
            self.element = element
            self.name = name
        }

        fileprivate func unpackDouble(_ string: String, forKey key: Key) throws -> Double {
            guard let value = Double(string) else {
                throw DecodingError.dataCorruptedError(
                    forKey: key,
                    in: self,
                    debugDescription: "Invalid double value: \(string)"
                )
            }
            return value
        }

        func contains(_ key: Key) -> Bool {
            element.contains(name: key.stringValue)
        }

        func decodeNil(forKey key: Key) throws -> Bool {
            false
        }

        func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool { fatalError() }

        func decode(_ type: String.Type, forKey key: Key) throws -> String {
            if let value = element.anyValue(with: key.stringValue) {
                return value
            }

            throw DecodingError.keyNotFound(
                key,
                DecodingError.Context(codingPath: codingPath, debugDescription: "Not found")
            )
        }

        func decode(_ type: Double.Type, forKey key: Key) throws -> Double {
            if let value = element.anyValue(with: key.stringValue) {
                return try unpackDouble(value, forKey: key)
            }

            throw DecodingError.keyNotFound(
                key,
                DecodingError.Context(codingPath: codingPath, debugDescription: "Not found")
            )
        }

        func decode(_ type: Float.Type, forKey key: Key) throws -> Float { fatalError() }
        func decode(_ type: Int.Type, forKey key: Key) throws -> Int { fatalError() }
        func decode(_ type: Int8.Type, forKey key: Key) throws -> Int8 { fatalError() }
        func decode(_ type: Int16.Type, forKey key: Key) throws -> Int16 { fatalError() }
        func decode(_ type: Int32.Type, forKey key: Key) throws -> Int32 { fatalError() }
        func decode(_ type: Int64.Type, forKey key: Key) throws -> Int64 { fatalError() }
        func decode(_ type: UInt.Type, forKey key: Key) throws -> UInt { fatalError() }
        func decode(_ type: UInt8.Type, forKey key: Key) throws -> UInt8 { fatalError() }
        func decode(_ type: UInt16.Type, forKey key: Key) throws -> UInt16 { fatalError() }
        func decode(_ type: UInt32.Type, forKey key: Key) throws -> UInt32 { fatalError() }
        func decode(_ type: UInt64.Type, forKey key: Key) throws -> UInt64 { fatalError() }

        func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T: Decodable {
            guard let child = element[key.stringValue] else {
                throw DecodingError.keyNotFound(
                    key,
                    DecodingError.Context(codingPath: codingPath, debugDescription: "Not found")
                )
            }
            if type is Date.Type {
                if let value = child.value {
                    if let date = DateFormatter.iso8601.date(from: value) as? T {
                        return date
                    }
                    if let date = DateFormatter.iso8601Full.date(from: value) as? T {
                        return date
                    }
                }
            }
            return try T(from: XMLDecoder(child, name: name))
        }

        func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type,
                                        forKey key: Key) throws -> KeyedDecodingContainer<NestedKey>
            where NestedKey: CodingKey {
                guard let child = element.find(path: key.stringValue) else {
                    throw DecodingError.keyNotFound(
                        key,
                        DecodingError.Context(codingPath: codingPath, debugDescription: "Not found")
                    )
                }
                return KeyedDecodingContainer(KDC<NestedKey>(child, name: name))
        }
        func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
            UDC(element, name: key.stringValue)
        }
        func superDecoder() throws -> Decoder { fatalError() }
        func superDecoder(forKey key: Key) throws -> Decoder { fatalError() }
    }

    struct UDC: UnkeyedDecodingContainer {

        var codingPath: [CodingKey] = []
        var count: Int?
        var isAtEnd: Bool
        var currentIndex: Int
        let elements: [XMLNode]
        let name: String?

        init(_ element: XMLNode, name: String?) {
            self.name = name
            self.elements = element.children.filter { $0.name == name }
            self.count = self.elements.count
            self.currentIndex = 0
            self.isAtEnd = currentIndex == self.count
        }

        mutating func decodeNil() throws -> Bool { fatalError() }
        mutating func decode(_ type: Bool.Type) throws -> Bool { fatalError() }
        mutating func decode(_ type: String.Type) throws -> String { fatalError() }
        mutating func decode(_ type: Double.Type) throws -> Double { fatalError() }
        mutating func decode(_ type: Float.Type) throws -> Float { fatalError() }
        mutating func decode(_ type: Int.Type) throws -> Int { fatalError() }
        mutating func decode(_ type: Int8.Type) throws -> Int8 { fatalError() }
        mutating func decode(_ type: Int16.Type) throws -> Int16 { fatalError() }
        mutating func decode(_ type: Int32.Type) throws -> Int32 { fatalError() }
        mutating func decode(_ type: Int64.Type) throws -> Int64 { fatalError() }
        mutating func decode(_ type: UInt.Type) throws -> UInt { fatalError() }
        mutating func decode(_ type: UInt8.Type) throws -> UInt8 { fatalError() }
        mutating func decode(_ type: UInt16.Type) throws -> UInt16 { fatalError() }
        mutating func decode(_ type: UInt32.Type) throws -> UInt32 { fatalError() }
        mutating func decode(_ type: UInt64.Type) throws -> UInt64 { fatalError() }

        mutating func decode<T>(_ type: T.Type) throws -> T where T: Decodable {
            defer {
                currentIndex += 1
                isAtEnd = currentIndex == count
            }
            let child = elements[currentIndex]
            return try T(from: XMLDecoder(child))
        }

        mutating func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type)
            throws -> KeyedDecodingContainer<NestedKey> where NestedKey: CodingKey { fatalError() }
        mutating func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer { fatalError() }
        mutating func superDecoder() throws -> Decoder { fatalError() }
    }

    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key: CodingKey {
        KeyedDecodingContainer(KDC(element, name: name))
    }

    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        UDC(element, name: name)
    }

    func singleValueContainer() throws -> SingleValueDecodingContainer { fatalError() }
}
