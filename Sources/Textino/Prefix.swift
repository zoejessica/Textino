import Foundation

public extension Parser where Output == Substring {
  static func prefix(while predicate: @escaping (Character) -> Bool) -> Self {
    Self() { input in
      guard input != "" else { return nil }
      let output = input.prefix(while: predicate)
      input.removeFirst(output.count)
      return output
    }
  }
}

extension Parser: ExpressibleByStringLiteral where Output == Void {
  public typealias StringLiteralType = String
  
  public static func prefix(_ p: String) -> Self {
    Self { input in
      guard input.hasPrefix(p) else { return nil }
      input.removeFirst(p.count)
      return ()
    }
  }
  
  public init(stringLiteral value: String) {
    self = .prefix(value)
  }
}

extension Parser: ExpressibleByUnicodeScalarLiteral where Output == Void {
  public typealias UnicodeScalarLiteralType = StringLiteralType
}
extension Parser: ExpressibleByExtendedGraphemeClusterLiteral where Output == Void {
  public typealias ExtendedGraphemeClusterLiteralType = StringLiteralType
}

public extension Parser where Output == Substring {
  static func prefix<T>(until delimiter: Parser<T>) -> Self {
    Self() { input in
      var rest = input
      var output: [Character] = []
      
      while input.isEmpty == false {
        guard delimiter.run(&input) == nil else {
          input = rest
          return Substring(output)
        }
        output.append(input.removeFirst())
        rest = input
      }
      guard output.isEmpty == false else { return nil }
      return Substring(output)
    }
  }
}
