//
//  ConvertCommand.swift
//
//  Created by Oleg Ketrar on 28.11.2023.
//

import Foundation
import ArgumentParser
import XCResult2Cobertura

struct ConvertCommand: AsyncParsableCommand {

  static let configuration = CommandConfiguration(
    commandName: "convert",
    abstract: "Covert .xcresult files to Cobertura XML")

  @Argument(
    help: "Path to .xcresult report",
    completion: .file(extensions: [".xcresult"]))
  var reportPath: String

  @Option(
    name: .long,
    help: "Output path to resulting XML file")
  var outputPath: String

  @Option(
    name: .long,
    help: "List of source code files")
  var changedFiles: [String]

  @Option(name: .long, help: "Path to project directory to run from Xcode during debug")
  var localDevPath: String?

  func run() async throws {
    let shell = makeShell()

    let converter = XCResult2Cobertura(
      reportPath: reportPath,
      outputPath: outputPath,
      changedFiles: changedFiles,
      shell: PrintableShell(shell))

    try await converter.convert()
  }

  func makeShell() -> Shell {
    if let localDevPath {
      return LocalDev(localDevPath).makeShell()
    } else {
      return SimpleShell()
    }
  }
}
