//
//  SimpleShell.swift
//
//  Created by Oleg Ketrar on 05.11.2022.
//

import Foundation
import Dispatch

public struct SimpleShell: Shell {
  public init() {}

  public func run(_ command: String) async -> ShellOutput {
    await withCheckedContinuation { continuation in
      DispatchQueue.global(qos: .background).async {
        let output = launchCommand(command)
        continuation.resume(returning: output)
      }
    }
  }

  public func launchCommand(_ command: String) -> ShellOutput {

    let process = Process()
    process.launchPath = "/bin/sh"
    process.arguments = ["-c", command]

    // Because FileHandle's readabilityHandler might be called from a
    // different queue from the calling queue, avoid a data race by
    // protecting reads and writes to outputData and errorData on
    // a single dispatch queue.
    let outputQueue = DispatchQueue(label: "shell-output-queue")

    var outputData = Data()
    var errorData = Data()

    let outputPipe = Pipe()
    let errorPipe = Pipe()

    outputPipe.fileHandleForReading.readabilityHandler = { handler in
      let data = handler.availableData
      outputQueue.async {
        outputData.append(data)
      }
    }

    errorPipe.fileHandleForReading.readabilityHandler = { handler in
      let data = handler.availableData
      outputQueue.async {
        errorData.append(data)
      }
    }

    process.standardOutput = outputPipe
    process.standardError = errorPipe

    process.launch()
    process.waitUntilExit()

    outputPipe.fileHandleForReading.readabilityHandler = nil
    errorPipe.fileHandleForReading.readabilityHandler = nil

    // Block until all writes have occurred to outputData and errorData,
    // and then read the data back out.
    return outputQueue.sync {
      ShellOutput(
        terminationStatus: process.terminationStatus,
        errorData: errorData,
        outputData: outputData)
    }
  }
}
