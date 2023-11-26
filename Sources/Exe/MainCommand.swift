//
//  MainCommand.swift
//
//  Created by Oleg Ketrar on 28.11.2023.
//

import ArgumentParser

@main
struct MainCommand: AsyncParsableCommand {

  static let configuration = CommandConfiguration(
    commandName: "xcr2c",
    abstract: "Covert .xcresult files to Cobertura XML",
    subcommands: [
      ConvertCommand.self
    ],
    defaultSubcommand: nil)

  func run() async throws {
    print(Self.helpMessage())
  }
}
