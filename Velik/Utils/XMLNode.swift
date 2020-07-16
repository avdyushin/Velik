//
//  XMLNode.swift
//  Velik
//
//  Created by Grigory Avdyushin on 02/07/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import Foundation

protocol XMLNode {
    var name: String { get }
    var value: String? { get set }
    var children: [XMLNode] { get set }
    var attributes: [String: String] { get set }
}

extension XMLNode {

    func attribute(name: String) -> String? {
        attributes.first { $0.key == name }?.value
    }

    private func firstChild<T: Equatable>(by keyPath: KeyPath<XMLNode, T>, with value: T) -> XMLNode? {
        children.first { $0[keyPath: keyPath] == value }
    }

    subscript(name: String) -> XMLNode? {
        firstChild(by: \.name, with: name)
    }

    func find(path: String) -> XMLNode? {
        var current: XMLNode? = self
        path.split(separator: "/").forEach {
            current = current?[String($0)]
        }
        return current
    }

    func contains(name: String) -> Bool {
        attributes.keys.contains { $0 == name} ||
            children.contains { $0.name == name }
    }

    func anyValue(with name: String) -> String? {
        attribute(name: name) ?? self[name]?.value
    }

    func traverse(from node: XMLNode, start: (XMLNode) -> Void, end: (XMLNode) -> Void) {
        start(node)
        node.children.forEach { traverse(from: $0, start: start, end: end) }
        end(node)
    }
}

extension XMLNode {

    func attributesAsString() -> String {
        guard !attributes.isEmpty else { return "" }
        return " " + attributes
            .map { "\($0) = \"\($1)\"" }
            .joined(separator: " ")
    }

    func asString(header: String = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>") -> String {
        var result = header + "\n"
        self.traverse(from: self, start: { node in
            result += "<\(node.name)\(node.attributesAsString())>\n"
            result += node.value ?? ""
        }, end: { node in
            result += "</\(node.name)>\n"
        })
        return result
    }
}
