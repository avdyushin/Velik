//
//  XMLDecoder.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 24/06/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import Foundation

class XMLDecoder: Decoder {

    typealias Filter = (XMLNode) -> Bool

    var codingPath: [CodingKey] = []
    var userInfo: [CodingUserInfoKey: Any] = [:]
    let element: XMLNode
    let filter: Filter?

    init(_ element: XMLNode, filter: Filter? = nil) {
        self.element = element
        self.filter = filter
    }

    struct KDC<Key: CodingKey>: KeyedDecodingContainerProtocol {
        var codingPath: [CodingKey] = []
        var allKeys: [Key] = []
        let element: XMLNode
        let filter: Filter?

        init(_ element: XMLNode, filter: Filter?) {
            self.element = element
            self.filter = filter
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
            element.attributes.keys.contains { $0 == key.stringValue} ||
            element.children.contains { $0.name == key.stringValue }
        }

        func decodeNil(forKey key: Key) throws -> Bool {
            fatalError()
        }

        func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool {
            fatalError()
        }

        func decode(_ type: String.Type, forKey key: Key) throws -> String {
            if let attributeValue = element.attribute(with: key.stringValue) {
                return attributeValue
            }

            if let nodeValue = element.child(with: key.stringValue)?.value {
                return nodeValue
            }

            throw DecodingError.keyNotFound(
                key,
                DecodingError.Context(codingPath: codingPath, debugDescription: "Not found")
            )
        }

        func decode(_ type: Double.Type, forKey key: Key) throws -> Double {
            if let attributeValue = element.attribute(with: key.stringValue) {
                return try unpackDouble(attributeValue, forKey: key)
            }

            if let nodeValue = element.child(with: key.stringValue)?.value {
                return try unpackDouble(nodeValue, forKey: key)
            }

            throw DecodingError.keyNotFound(
                key,
                DecodingError.Context(codingPath: codingPath, debugDescription: "Not found")
            )
        }

        func decode(_ type: Float.Type, forKey key: Key) throws -> Float {
            fatalError()
        }

        func decode(_ type: Int.Type, forKey key: Key) throws -> Int {
            fatalError()
        }

        func decode(_ type: Int8.Type, forKey key: Key) throws -> Int8 {
            fatalError()
        }

        func decode(_ type: Int16.Type, forKey key: Key) throws -> Int16 {
            fatalError()
        }

        func decode(_ type: Int32.Type, forKey key: Key) throws -> Int32 {
            fatalError()
        }

        func decode(_ type: Int64.Type, forKey key: Key) throws -> Int64 {
            fatalError()
        }

        func decode(_ type: UInt.Type, forKey key: Key) throws -> UInt {
            fatalError()
        }

        func decode(_ type: UInt8.Type, forKey key: Key) throws -> UInt8 {
            fatalError()
        }

        func decode(_ type: UInt16.Type, forKey key: Key) throws -> UInt16 {
            fatalError()
        }

        func decode(_ type: UInt32.Type, forKey key: Key) throws -> UInt32 {
            fatalError()
        }

        func decode(_ type: UInt64.Type, forKey key: Key) throws -> UInt64 {
            fatalError()
        }

        func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T: Decodable {
            guard let child = element.child(with: key.stringValue) else {
                throw DecodingError.keyNotFound(
                    key,
                    DecodingError.Context(codingPath: codingPath, debugDescription: "Not found")
                )
            }
            return try T(from: XMLDecoder(child, filter: filter))
        }

        func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type,
                                        forKey key: Key) throws -> KeyedDecodingContainer<NestedKey>
            where NestedKey: CodingKey {
            fatalError()
        }

        func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
            fatalError()
        }

        func superDecoder() throws -> Decoder {
            fatalError()
        }

        func superDecoder(forKey key: Key) throws -> Decoder {
            fatalError()
        }
    }

    struct SVDC: SingleValueDecodingContainer {
        var codingPath: [CodingKey] = []
        let element: XMLNode

        init(_ element: XMLNode) {
            self.element = element
        }

        func decodeNil() -> Bool {
            fatalError()
        }

        func decode(_ type: Bool.Type) throws -> Bool {
            fatalError()
        }

        func decode(_ type: String.Type) throws -> String {
            fatalError()
        }

        static var dateFormatter: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            return dateFormatter
        }()

        func decode(_ type: Double.Type) throws -> Double {
            guard let string = element.value else {
                throw DecodingError.dataCorruptedError(
                    in: self,
                    debugDescription: "Invalid format: \(String(describing: element.value))"
                )
            }
            if let double = Double(string) {
                return double
            }
            if let date = SVDC.dateFormatter.date(from: string) {
                return date.timeIntervalSinceReferenceDate
            }

            throw DecodingError.dataCorruptedError(
                in: self,
                debugDescription: "Invalid format: \(String(describing: element.value))"
            )
        }

        func decode(_ type: Float.Type) throws -> Float {
            fatalError()
        }

        func decode(_ type: Int.Type) throws -> Int {
            fatalError()
        }

        func decode(_ type: Int8.Type) throws -> Int8 {
            fatalError()
        }

        func decode(_ type: Int16.Type) throws -> Int16 {
            fatalError()
        }

        func decode(_ type: Int32.Type) throws -> Int32 {
            fatalError()
        }

        func decode(_ type: Int64.Type) throws -> Int64 {
            fatalError()
        }

        func decode(_ type: UInt.Type) throws -> UInt {
            fatalError()
        }

        func decode(_ type: UInt8.Type) throws -> UInt8 {
            fatalError()
        }

        func decode(_ type: UInt16.Type) throws -> UInt16 {
            fatalError()
        }

        func decode(_ type: UInt32.Type) throws -> UInt32 {
            fatalError()
        }

        func decode(_ type: UInt64.Type) throws -> UInt64 {
            fatalError()
        }

        func decode<T>(_ type: T.Type) throws -> T where T: Decodable {
            fatalError()
        }
    }

    struct UDC: UnkeyedDecodingContainer {

        var codingPath: [CodingKey] = []
        var count: Int?
        var isAtEnd: Bool = false
        var currentIndex: Int = 0
        let elements: [XMLNode]
        let filter: Filter

        init(_ element: XMLNode, filter: Filter?) {
            self.filter = filter ?? { _ in true }
            self.elements = element.children.filter(self.filter)
            self.count = self.elements.count
        }

        mutating func decodeNil() throws -> Bool {
            fatalError()
        }

        mutating func decode(_ type: Bool.Type) throws -> Bool {
            fatalError()
        }

        mutating func decode(_ type: String.Type) throws -> String {
            fatalError()
        }

        mutating func decode(_ type: Double.Type) throws -> Double {
            fatalError()
        }

        mutating func decode(_ type: Float.Type) throws -> Float {
            fatalError()
        }

        mutating func decode(_ type: Int.Type) throws -> Int {
            fatalError()
        }

        mutating func decode(_ type: Int8.Type) throws -> Int8 {
            fatalError()
        }

        mutating func decode(_ type: Int16.Type) throws -> Int16 {
            fatalError()
        }

        mutating func decode(_ type: Int32.Type) throws -> Int32 {
            fatalError()
        }

        mutating func decode(_ type: Int64.Type) throws -> Int64 {
            fatalError()
        }

        mutating func decode(_ type: UInt.Type) throws -> UInt {
            fatalError()
        }

        mutating func decode(_ type: UInt8.Type) throws -> UInt8 {
            fatalError()
        }

        mutating func decode(_ type: UInt16.Type) throws -> UInt16 {
            fatalError()
        }

        mutating func decode(_ type: UInt32.Type) throws -> UInt32 {
            fatalError()
        }

        mutating func decode(_ type: UInt64.Type) throws -> UInt64 {
            fatalError()
        }

        mutating func decode<T>(_ type: T.Type) throws -> T where T: Decodable {
            defer {
                currentIndex += 1
                isAtEnd = currentIndex == count
            }
            let child = elements[currentIndex]
            return try T(from: XMLDecoder(child, filter: filter))
        }

        mutating func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type)
            throws -> KeyedDecodingContainer<NestedKey> where NestedKey: CodingKey {
            fatalError()
        }

        mutating func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
            fatalError()
        }

        mutating func superDecoder() throws -> Decoder {
            fatalError()
        }
    }

    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key: CodingKey {
        KeyedDecodingContainer(KDC(element, filter: filter))
    }

    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        UDC(element, filter: filter)
    }

    func singleValueContainer() throws -> SingleValueDecodingContainer {
        SVDC(element)
    }
}
