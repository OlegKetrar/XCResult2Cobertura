//
//  WholeXcovReport.swift
//
//  Created by Oleg Ketrar on 29.11.2023.
//

import Foundation

struct WholeXcovReport: Codable {

  struct Target: Codable {
    var files: [File]
  }

  struct File: Codable {
    var coveredLines: Int
    var executableLines: Int
    var lineCoverage: Double
    var path: String
  }

  var coveredLines: Int
  var executableLines: Int
  var lineCoverage: Double
  var targets: [Target]
}
