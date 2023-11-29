//
//  ConvertCommand.swift
//
//  Created by Oleg Ketrar on 28.11.2023.
//

import Foundation
import ArgumentParser
import XCResult2Cobertura

@main
struct ConvertCommand: AsyncParsableCommand {

  static let configuration = CommandConfiguration(
    commandName: "xcr2c",
    abstract: "Covert .xcresult files to Cobertura XML")

  @Argument(
    help: "Path to .xcresult report",
    completion: .file(extensions: [".xcresult"]))
  var reportPath: String

  @Option(
    name: .long,
    help: "Output path to resulting XML file")
  var outputPath: String

  @Argument(
    help: "List of files to filter the report",
    completion: .file())
  var changedFiles: [String]

#if !RELEASE
  @Option(name: .long, help: "Path to project directory to run from Xcode during debug")
  var localDevPath: String?
#endif

  @Flag(help: "Print executed shell commands")
  var verbose: Bool = false

  func run() async throws {
    var shell: Shell = makeShell()

    if verbose {
      shell = PrintableShell(shell)
    }

    let converter = XCResult2Cobertura(
      reportPath: reportPath,
      outputPath: outputPath,
      changedFiles: changedFiles,
      shell: shell)

    try await converter.convert()
  }

  func makeShell() -> Shell {
    if let localDevPath {
      return LocalDev(localDevPath).makeShell()
    } else {
      return SimpleShell()
    }
  }

  func testParameters() {
    print("reportPath: \(reportPath)")
    print("outputPath: \(outputPath)")
    print("changedFiles start count: \(changedFiles.count)")

    for file in changedFiles {
      print("-- \(file)")
    }

    print("changedFiles end")
  }
}
