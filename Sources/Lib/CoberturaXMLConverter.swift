//
//  CoberturaXMLConverter.swift
//
//  Created by Oleg Ketrar on 29.11.2023.
//

import Foundation

struct GenericError: Swift.Error {
    let message: String

    init(_ message: String) {
        self.message = message
    }
}

public struct CoberturaXMLEncoder {

    func encode(report: CoberturaXML) throws -> Data {
        let rootElement = try makeRootElement(report: report)

        let doc = XMLDocument(rootElement: rootElement)
        doc.version = "1.0"
        doc.dtd = try makeDTD()
        doc.documentContentKind = .xml

        let sourceElement = XMLElement(name: "sources")
        rootElement.addChild(sourceElement)
        sourceElement.addChild(XMLElement(name: "source", stringValue: report.sources))

        let packagesElement = XMLElement(name: "packages")
        rootElement.addChild(packagesElement)

        try report.packages.forEach { package in
            let packageElement = XMLElement(name: "package")

            try packageElement.addAttribute(.node(name: "name", value: package.name))
            try packageElement.addAttribute(.node(name: "line-rate", value: package.lineRate))
            try packageElement.addAttribute(.node(name: "branch-rate", value: package.branchRate))
            try packageElement.addAttribute(.node(name: "complexity", value: package.complexity))

            let classesElement = XMLElement(name: "classes")
            try package.files.forEach { file in
                let classElement = XMLElement(name: "class")
                try classElement.addAttribute(.node(name: "name", value: file.name))
                try classElement.addAttribute(.node(name: "filename", value: file.filename))
                try classElement.addAttribute(.node(name: "line-rate", value: file.lineRate))
                try classElement.addAttribute(.node(name: "branch-rate", value: file.branchRate))
                try classElement.addAttribute(.node(name: "complexity", value: file.complexity))

                let linesElement = XMLElement(name: "lines")

                try file.lines.forEach { line in
                    let lineElement = XMLElement(kind: .element, options: .nodeCompactEmptyElement)
                    lineElement.name = "line"

                    try lineElement.addAttribute(.node(name: "number", value: line.number))
                    try lineElement.addAttribute(.node(name: "branch", value: line.branch))
                    try lineElement.addAttribute(.node(name: "hits", value: line.hits))

                    linesElement.addChild(lineElement)
                }

                classElement.addChild(linesElement)
                classesElement.addChild(classElement)
            }

            packageElement.addChild(classesElement)
            packagesElement.addChild(packageElement)
        }

        let xmlString = doc.xmlString(options: [.nodePrettyPrint])
        let xmlData = xmlString.data(using: .utf8)

        if let xmlData {
            return xmlData
        } else {
            throw GenericError("cant convert XMLDocument to Data")
        }
    }

    func makeDTD() throws -> XMLDTD {
        let urlStr = "http://cobertura.sourceforge.net/xml/coverage-04.dtd"

        guard let url = URL(string: urlStr) else {
            throw GenericError("cant create URL from String")
        }

        let dtd = try XMLDTD(contentsOf: url)
        dtd.name = "coverage"
        dtd.systemID = urlStr

        return dtd
    }

    func makeRootElement(report: CoberturaXML) throws -> XMLElement {
        let rootElement = XMLElement(name: "coverage")
        try rootElement.addAttribute(.node(name: "line-rate", value: report.lineRate))
        try rootElement.addAttribute(.node(name: "branch-rate", value: report.branchRate))
        try rootElement.addAttribute(.node(name: "lines-covered", value: report.linesCovered))
        try rootElement.addAttribute(.node(name: "lines-valid", value: report.linesValid))
        try rootElement.addAttribute(.node(name: "timestamp", value: report.timestamp))
        try rootElement.addAttribute(.node(name: "version", value: report.version))
        try rootElement.addAttribute(.node(name: "complexity", value: report.complexity))
        try rootElement.addAttribute(.node(name: "branches-valid", value: report.branchesValid))
        try rootElement.addAttribute(.node(name: "branches-covered", value: report.branchesCovered))

        return rootElement
    }
}

private extension XMLNode {

    static func node(name: String, value: String) throws -> XMLNode {
        guard let attribute = XMLNode.attribute(withName: name, stringValue: value) as? XMLNode else {
            throw GenericError("cant create XMLNode (name: \(name) value: \(value)")
        }

        return attribute
    }
}
