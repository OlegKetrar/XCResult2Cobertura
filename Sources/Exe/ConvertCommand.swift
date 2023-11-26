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

  func run() async throws {

  }
}
