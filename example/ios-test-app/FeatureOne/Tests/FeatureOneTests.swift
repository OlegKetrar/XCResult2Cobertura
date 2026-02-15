import XCTest
import FeatureOne

final class FeatureOneTests: XCTestCase {

    func testExample() throws {
      var sut = FeatureOne(isEnabled: false)
      XCTAssertFalse(sut.isDone)

      sut.doSomething()
      XCTAssertFalse(sut.isDone)
    }
}
