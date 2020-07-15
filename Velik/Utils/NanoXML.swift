//
//  NanoXML.swift
//  Velik
//
//  Created by Grigory Avdyushin on 24/06/2020.
//  Copyright © 2020 Grigory Avdyushin. All rights reserved.
//

import Foundation

class NanoXML: NSObject, XMLParserDelegate {

    var error: Error?

    private var stack = [XMLElement]()
    private let xmlString: String
    private(set) var root: XMLElement?

    init(xmlString: String) {
        self.xmlString = xmlString
        let parser = XMLParser(data: xmlString.data(using: .utf8)!)
        super.init()
        parser.delegate = self
        parser.parse()
    }

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
