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

    var stack = [XMLNode]()
    let xmlString: String
    var lastError: Error? {
        didSet {
            if let error = lastError {
                debugPrint("got error", error)
            }
        }
    }
    var root: XMLNode?

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

    func parserDidStartDocument(_ parser: XMLParser) {
        debugPrint("start")
    }

    func parserDidEndDocument(_ parser: XMLParser) {
        debugPrint("stop")
    }

    func parser(_ parser: XMLParser,
                didStartElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?,
                attributes attributeDict: [String: String] = [:]) {
        debugPrint("ele ->", elementName)
        let element = XMLElement(elementName, attributes: attributeDict)
        if stack.isEmpty {
            root = element
        } else {
            stack[stack.count - 1].children.append(element)
        }
        stack.append(element)
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let value = string.trimmingCharacters(in: .whitespacesAndNewlines)
        if !value.isEmpty {
            stack[stack.count - 1].value = string
        }
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
        lastError = parseError
    }
}
