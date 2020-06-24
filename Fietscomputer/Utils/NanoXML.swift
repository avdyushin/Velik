//
//  NanoXML.swift
//  Fietscomputer
//
//  Created by Grigory Avdyushin on 24/06/2020.
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

    func attribute(with name: String) -> String? {
        attributes.first { $0.key == name }?.value
    }

    func child(with name: String) -> XMLNode? {
        children.first { $0.name == name }
    }

    func contains(name: String) -> Bool {
        attributes.keys.contains { $0 == name} ||
        children.contains { $0.name == name }
    }

    func anyValue(with name: String) -> String? {
        attribute(with: name) ?? child(with: name)?.value
    }
}

class XMLElement: XMLNode {
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

class NanoXML: NSObject {

    var error: Error?

    private var stack = [XMLNode]()
    private let xmlString: String
    private var root: XMLNode?

    init(xmlString: String) {
        self.xmlString = xmlString
        let parser = XMLParser(data: xmlString.data(using: .utf8)!)
        super.init()
        parser.delegate = self
        parser.parse()
    }

    func rootNode() -> XMLNode? { root }
}

extension NanoXML: XMLParserDelegate {

    func parser(_ parser: XMLParser,
                didStartElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?,
                attributes attributeDict: [String: String] = [:]) {
        let element = XMLElement(elementName, attributes: attributeDict)
        if stack.isEmpty {
            root = element
        } else {
            stack[stack.count - 1].children.append(element)
        }
        stack.append(element)
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        stack[stack.count - 1].value = string.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    func parser(_ parser: XMLParser,
                didEndElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?) {
        if stack[stack.count - 1].name == elementName {
            _ = stack.popLast()
        }
    }

    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        error = parseError
    }
}
