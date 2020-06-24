//
//  XMLDecoder.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 24/06/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import Foundation

class XMLDecoder: Decoder {

    var codingPath: [CodingKey] = []
    var userInfo: [CodingUserInfoKey: Any] = [:]
    let element: XMLNode

    init(_ element: XMLNode) {
        self.element = element
    }

    struct KDC<Key: CodingKey>: KeyedDecodingContainerProtocol {
        var codingPath: [CodingKey] = []
        var allKeys: [Key] = []
        let element: XMLNode

            init(_ element: XMLNode) {
            self.element = element
        }

        func contains(_ key: Key) -> Bool {
            true
        }

        func decodeNil(forKey key: Key) throws -> Bool {
            false
        }

        func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool {
            fatalError()
        }

        func decode(_ type: String.Type, forKey key: Key) throws -> String {
            fatalError()
        }

        func decode(_ type: Double.Type, forKey key: Key) throws -> Double {
            fatalError()
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
            try T(from: XMLDecoder(element))
//            if type is UUID.Type {
//                let uuidString = try decode(String.self, forKey: key)
//                return UUID(uuidString: uuidString) as! T
//            } else {
//                throw DecodingError.dataCorrupted(
//                    DecodingError.Context(codingPath: codingPath, debugDescription: "Unsupported type: \(type)")
//                )
//            }
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
            element.value ?? "Unknown"
        }

        func decode(_ type: Double.Type) throws -> Double {
            fatalError()
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

    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key: CodingKey {
        KeyedDecodingContainer(KDC(element))
    }

    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        fatalError()
    }

    func singleValueContainer() throws -> SingleValueDecodingContainer {
        SVDC(element)
    }
}
