//
//  ViewControllerTests.swift
//  ios-test-appTests
//
//  Created by Oleg Ketrar on 27.11.2023.
//

import XCTest
@testable import ios_test_app

final class ViewControllerTests: XCTestCase {

    func test_onDidLoad() throws {
      var onDidLoad_callsCount = 0

      let sut = ViewController()
      sut.onDidLoad = { 
        onDidLoad_callsCount += 1
      }

      XCTAssertEqual(onDidLoad_callsCount, 0)

      sut.loadViewIfNeeded()
      XCTAssertEqual(onDidLoad_callsCount, 1)
    }
}
