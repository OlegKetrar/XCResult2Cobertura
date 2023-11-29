//
//  PrintableShell.swift
//
//  Created by Oleg Ketrar on 31.03.2023.
//

import Foundation

public struct PrintableShell: Shell {
  let shell: Shell

  public init(_ shell: Shell) {
    self.shell = shell
  }

  public func run(_ command: String) async -> ShellOutput {
    Swift.print("--> \(command)")
    return await shell.run(command)
  }
}
