import Foundation

public extension Parser where Output == Void {
  static func consume<T>(_ p: Parser<T>) -> Self {
    Self { input in
      guard p.run(&input) != nil else { return nil }
      return ()
    }
  }
  
  static func consumeIfPresent<T>(_ p: Parser<T>) -> Self {
    Self { input in
      _ = p.run(&input)
      return ()
    }
  }
}
