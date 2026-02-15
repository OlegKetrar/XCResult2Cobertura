//
//  AppDelegateTests.swift
//  ios-test-appTests
//
//  Created by Oleg Ketrar on 27.11.2023.
//

import XCTest
@testable import ios_test_app

final class AppDelegateTests: XCTestCase {

  func test_makeViewController() {
    let sut = AppDelegate()
    let vc = sut.makeViewController(isFirst: false)

    XCTAssertEqual(vc.title, "Second screen")
  }
}
