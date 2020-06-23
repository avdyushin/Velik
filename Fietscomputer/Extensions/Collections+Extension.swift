//
//  Collections+Extension.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 20/06/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import Foundation

extension Collection where Index == Int {
    func chunked(size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0+size, count)])
        }
    }
}

extension Sequence where Element: AdditiveArithmetic {
    func sum() -> Element { reduce(.zero, +) }
}

extension Collection where Element: BinaryInteger {
    func average() -> Element { isEmpty ? .zero : sum() / Element(count) }
}

extension Collection where Element: BinaryFloatingPoint {
    func average() -> Element { isEmpty ? .zero : sum() / Element(count) }
}

extension Collection {
    func average<T: BinaryFloatingPoint>(by keyPath: KeyPath<Element, T>) -> T {
        self.map { $0[keyPath: keyPath] }.average()
    }
}

extension Sequence {

    func sum<T: AdditiveArithmetic>(by keyPath: KeyPath<Element, T>) -> T {
        self.map { $0[keyPath: keyPath] }.sum()
    }

    func max<T: Comparable>(by keyPath: KeyPath<Element, T>) -> Element? {
        self.max { $0[keyPath: keyPath] < $1[keyPath: keyPath] }
    }

    func min<T: Comparable>(by keyPath: KeyPath<Element, T>) -> Element? {
        self.min { $0[keyPath: keyPath] < $1[keyPath: keyPath] }
    }

    func sorted<T: Comparable>(by keyPath: KeyPath<Element, T>) -> [Self.Element] {
        self.sorted { $0[keyPath: keyPath] < $1[keyPath: keyPath] }
    }
}

extension NSSet {

    func toTypedArray<T>() -> [T] {
        compactMap { $0 as? T }
    }
}
