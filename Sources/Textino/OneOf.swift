import Foundation

public extension Parser {
  static func oneOf(_ parsers: [Self]) -> Self {
    Self() { input in
      for parser in parsers {
        if let match = parser.run(&input) {
          return match
        }
      }
      return nil
    }
  }
  
  static func oneOf(_ parsers: Self...) -> Self {
    oneOf(parsers)
  }
}
