//
//  LocalDevShell.swift
//
//  Created by Oleg Ketrar on 10.11.2022.
//

import Foundation

public struct LocalDev {
  public let path: String

  public init(_ path: String) {
    self.path = path
  }

  public func makeShell() -> Shell {
    LocalDevShell(shell: SimpleShell(), path: path)
  }
}

struct LocalDevShell: Shell {
  let shell: Shell
  let path: String

  init(shell: Shell, path: String) {
    self.shell = shell
    self.path = path
  }

  func run(_ command: String) async -> ShellOutput {
    await shell.run("cd \(path); \(command)")
  }
}
