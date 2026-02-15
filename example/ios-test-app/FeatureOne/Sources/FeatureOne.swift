
public struct FeatureOne {
  public let isEnabled: Bool
  public var isDone: Bool

  public init(isEnabled: Bool) {
    self.isEnabled = isEnabled
    self.isDone = false
  }

  public mutating func doSomething() {
    if isEnabled {
      isDone = true
    } else {
      isDone = false
    }
  }
}
