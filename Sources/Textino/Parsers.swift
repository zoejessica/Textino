import Foundation

public extension Parser where Output == Character {
  static let char = Self { input in
    guard !input.isEmpty else { return nil }
    return input.removeFirst()
  }
}

public extension Parser {
  static func always(_ output: Output) -> Self {
    Self { _ in output }
  }
  
  static var never: Self {
    Self { _ in nil }
  }
}
