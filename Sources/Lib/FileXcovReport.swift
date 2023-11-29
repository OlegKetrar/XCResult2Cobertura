//
//  FileXcovReport.swift
//
//  Created by Oleg Ketrar on 29.11.2023.
//

import Foundation

struct FileXcovReport {

  struct Line: Codable {
    var isExecutable: Bool
    var line: Int
    var executionCount: Int?
  }

  var filepath: String
  var lines: [Line]
}

extension FileXcovReport: Decodable {

  init(from decoder: Decoder) throws {

    let dict = try decoder
      .singleValueContainer()
      .decode([String : [FileXcovReport.Line]].self)

    guard let path = dict.keys.first else {
      throw GenericError("")
    }

    self.filepath = path
    self.lines = dict[path] ?? []
  }
}
