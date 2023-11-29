//
//  GenericError.swift
//
//  Created by Oleg Ketrar on 05.11.2022.
//

import Foundation

public struct GenericError: Swift.Error, CustomStringConvertible, LocalizedError {
  public let message: String

  public init(
    _ message: String = "generic error",
    _ file: StaticString = #file,
    _ function: StaticString = #function,
    _ line: UInt = #line
  ) {

    let fileStr = "\(file)"
    let fileName = (fileStr as NSString).lastPathComponent

    self.message = "\(fileName):\(function):\(line) - \(message)"
  }

  public var description: String { message }
  public var localizedDescription: String { message }
  public var errorDescription: String? { message }
}
