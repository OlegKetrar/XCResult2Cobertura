//
//  Shell.swift
//
//  Created by Oleg Ketrar on 05.11.2022.
//

import Foundation

public protocol Shell {
  func run(_ command: String) async -> ShellOutput
}

public struct ShellOutput {
  public let status: Int32
  public let data: Data
  public let message: String?
  public let errorData: Data
  public let errorMessage: String?

  public init(terminationStatus: Int32, errorData: Data, outputData: Data) {
    self.status = terminationStatus
    self.data = outputData
    self.message = outputData.shellOutput()
    self.errorData = errorData
    self.errorMessage = errorData.shellOutput()
  }

  public var isSuccess: Bool {
    status == 0
  }

  public func getData(
    _ file: StaticString = #file,
    _ function: StaticString = #function,
    _ line: UInt = #line
  ) throws -> Data {

    if isSuccess {
      return data
    } else {
      throw GenericError(errorMessage ?? "<no message>", file, function, line)
    }
  }

  public func get(
    _ file: StaticString = #file,
    _ function: StaticString = #function,
    _ line: UInt = #line
  ) throws -> String {

    if isSuccess {
      return message ?? "<no message>"
    } else {
      throw GenericError(errorMessage ?? "<no message>", file, function, line)
    }
  }
}

private extension Data {

  func shellOutput() -> String? {
    guard let output = String(data: self, encoding: .utf8) else {
      return nil
    }

    guard !output.hasSuffix("\n") else {
      let endIndex = output.index(before: output.endIndex)
      return String(output[..<endIndex])
    }

    return output
  }
}
