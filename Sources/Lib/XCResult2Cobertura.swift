//
//  XCResult2Cobertura.swift
//
//  Created by Oleg Ketrar on 28.11.2023.
//

import Foundation

public struct XCResult2Cobertura {

  var reportPath: String
  var outputPath: String
  var changedFiles: [String]
  var shell: Shell

  public init(
    reportPath: String,
    outputPath: String,
    changedFiles: [String],
    shell: Shell
  ) {
    self.reportPath = reportPath
    self.outputPath = outputPath
    self.changedFiles = changedFiles
    self.shell = shell
  }

  public func convert() async throws {
    let currentDir = try await shell.run("pwd").get()

    let wholeReport: WholeXcovReport = try await parseJson(from: "xcrun xccov view", [
      "--report",
      "--json \(reportPath)"
    ])

    let fileList = try await shell.run("xcrun xccov view", arguments: [
      "--archive",
      "--file-list \(reportPath)"
    ])
    .get()
    .components(separatedBy: "\n")

    let allFilesXcov = wholeReport.targets.flatMap(\.files)
    var packages: [String : CoberturaXML.Package] = [:]

    for relPath in changedFiles {
      let absPath = currentDir.ns.appendingPathComponent(relPath)

      guard fileList.contains(absPath) else {
        continue
      }

      let fileReport: FileXcovReport = try await parseJson(from: "xcrun xccov view", [
        "--archive",
        "--file \(absPath)",
        "--json \(reportPath)"
      ])

      let fileData = allFilesXcov.first(where: {
        $0.path == fileReport.filepath
      })

      guard let fileData else { fatalError() }

      let fileDir = relPath.ns.deletingLastPathComponent

      var package = packages[fileDir] ?? CoberturaXML.Package(
        name: fileDir.convertToPackageName(),
        lineRate: "\(fileData.lineCoverage)",
        files: [])

      let newClass = CoberturaXML.PackageClass(
        name: relPath.ns.deletingPathExtension.convertToPackageName(),
        filename: relPath,
        lineRate: "\(fileData.lineCoverage)",
        lines: fileReport.lines.filter(\.isExecutable).map {
          CoberturaXML.FileLine(
            number: "\($0.line)",
            hits: "\($0.executionCount ?? 0)")
        })

      package.files.append(newClass)

      packages[fileDir] = package
    }

    let cobertura = CoberturaXML(
      sources: currentDir,
      lineRate: "\(wholeReport.lineCoverage)",
      linesCovered: "\(wholeReport.coveredLines)",
      linesValid: "\(wholeReport.executableLines)",
      timestamp: "\(Date().timeIntervalSince1970)",
      version: "diff_coverage 0.1",
      packages: Array(packages.values))

    let xmlData = try CoberturaXMLEncoder().encode(report: cobertura)
    let finalPath = currentDir.ns.appendingPathComponent(outputPath)

    let isSuccess = FileManager.default.createFile(
      atPath: finalPath,
      contents: xmlData)

    if isSuccess == false {
      throw GenericError("cant write Data to file \(finalPath)")
    }
  }

  func parseJson<T: Decodable>(
    from command: String,
    _ arguments: [String] = []
  ) async throws -> T {

    let result = await shell.run(command, arguments: arguments)
    let jsonData = try result.getData()

    return try JSONDecoder().decode(T.self, from: jsonData)
  }
}

extension String {

  var ns: NSString {
    self as NSString
  }

  func convertToPackageName() -> String {
    var mutSelf = self

    if mutSelf.hasPrefix(".") {
      mutSelf.removeFirst()
    }

    if mutSelf.hasPrefix("/") {
      mutSelf.removeFirst()
    }

    if mutSelf.hasSuffix("/") {
      mutSelf.removeLast()
    }

    return mutSelf
      .components(separatedBy: "/")
      .joined(separator: ".")
  }
}

extension Shell {

  func run(_ command: String, arguments: [String]) async -> ShellOutput {
    let wholeCommand = ([command] + arguments).joined(separator: " ")

    return await run(wholeCommand)
  }
}

