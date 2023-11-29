//
//  CoberturaXML.swift
//
//  Created by Oleg Ketrar on 29.11.2023.
//

import Foundation

struct CoberturaXML: Codable {

  struct Package: Codable {
    var name: String
    var lineRate: String
    var branchRate: String = "1"
    var complexity: String = "0"
    var files: [PackageClass]
  }

  struct PackageClass: Codable {
    var name: String
    var filename: String
    var lineRate: String
    var branchRate: String = "1"
    var complexity: String = "0"
    var lines: [FileLine]
  }

  struct FileLine: Codable {
    var number: String
    var branch: String = "false"
    var hits: String
  }

  var sources: String
  var lineRate: String
  var linesCovered: String
  var linesValid: String
  var timestamp: String
  var version: String
  var branchRate: String = "1"
  var complexity: String = "0"
  var branchesValid: String = "1"
  var branchesCovered: String = "1"
  var packages: [Package]
}
