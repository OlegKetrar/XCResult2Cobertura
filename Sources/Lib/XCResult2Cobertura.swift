//
//  XCResult2Cobertura.swift
//
//  Created by Oleg Ketrar on 28.11.2023.
//

import Foundation
import ShellOut

struct WholeXcovReport: Codable {

    struct Target: Codable {
        var files: [File]
    }

    struct File: Codable {
        var coveredLines: Int
        var executableLines: Int
        var lineCoverage: Double
        var path: String
    }

    var coveredLines: Int
    var executedLines: Int
    var lineCoverage: Double
    var targets: [Target]
}

struct FileXcovReport: Codable {

    struct Line: Codable {
        var isExecutable: Bool
        var line: Int
        var executionCount: Int
    }

    var filepath: String
    var lines: [Line]
}

struct CoberturaXML: Codable {

    struct Package: Codable {
        var name: String
        var lineRate: String
        var branchRate: String = "1"
        var complexity: String = "0"
        var files: [PackageClass]
    }

    struct PackageClass: Codable {
        var name: String
        var filename: String
        var lineRate: String
        var branchRate: String = "1"
        var complexity: String = "0"
        var lines: [FileLine]
    }

    struct FileLine: Codable {
        var number: String
        var branch: String = "false"
        var hits: String
    }

    var sources: String
    var lineRate: String
    var linesCovered: String
    var linesValid: String
    var timestamp: String
    var version: String
    var branchRate: String = "1"
    var complexity: String = "0"
    var branchesValid: String = "1"
    var branchesCovered: String = "1"
    var packages: [Package]
}

public struct XCResult2Cobertura {

    var reportPath: String
    var outputPath: String
    var changedFiles: [String]

    public init(reportPath: String, outputPath: String, changedFiles: [String]) {
        self.reportPath = reportPath
        self.outputPath = outputPath
        self.changedFiles = changedFiles
    }

    public func convert() throws {

        let wholeReport: WholeXcovReport = try parseJson(from: "xcrun xcov view", [
            "--report",
            "--json \(reportPath)"
        ])

        let fileList = try shellOut(to: "xcrun xcov view", arguments: [
            "--archive",
            "--file-list \(reportPath)"
        ])
        .components(separatedBy: "\n")

        let allFilesXcov = wholeReport.targets.flatMap(\.files)
        var packages: [String : CoberturaXML.Package] = [:]

        for relPath in changedFiles where fileList.contains(relPath) {
            let fileReport: FileXcovReport = try parseJson(from: "xcrun xcov view", [
                "--archive",
                "--file \(relPath)",
                "--json \(reportPath)"
            ])

            let fileData = allFilesXcov.first(where: {
                $0.path == fileReport.filepath
            })

            guard let fileData else { fatalError() }

            let fileDir = relPath.ns.deletingLastPathComponent

            var package = packages[fileDir] ?? CoberturaXML.Package(
                name: fileDir.ns.pathComponents.joined(separator: "."),
                lineRate: "\(fileData.lineCoverage)",
                files: [])

            let newClass = CoberturaXML.PackageClass(
                name: relPath.ns.deletingPathExtension,
                filename: relPath,
                lineRate: "\(fileData.lineCoverage)",
                lines: fileReport.lines.filter(\.isExecutable).map {
                    CoberturaXML.FileLine(
                        number: "\($0.line)",
                        hits: "\($0.executionCount)")
                })

            package.files.append(newClass)

            packages[fileDir] = package
        }

        let cobertura = CoberturaXML(
            sources: FileManager.default.currentDirectoryPath,
            lineRate: "\(wholeReport.lineCoverage)",
            linesCovered: "\(wholeReport.coveredLines)",
            linesValid: "\(wholeReport.executedLines)",
            timestamp: "\(Date().timeIntervalSince1970)",
            version: "diff_coverage 0.1",
            packages: Array(packages.values))

        let xmlData = try CoberturaXMLEncoder().encode(report: cobertura)

        let isSuccess = FileManager.default.createFile(
            atPath: outputPath,
            contents: xmlData)

        if isSuccess == false {
            throw GenericError("cant write Data to file \(outputPath)")
        }
    }

    func parseJson<T: Decodable>(from command: String, _ arguments: [String] = []) throws -> T {

        let jsonStr = try shellOut(to: command, arguments: arguments)

        guard let jsonData = jsonStr.data(using: .utf8) else {
            fatalError()
        }

        return try JSONDecoder().decode(T.self, from: jsonData)
    }
}

extension String {

    var ns: NSString {
        self as NSString
    }
}
