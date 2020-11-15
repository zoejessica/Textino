import Foundation

public struct Parser<Output> {
  public let run: (inout Substring) -> Output?
}

public extension Parser {
  func run(_ input: String) -> (match: Output?, rest: Substring) {
    var input = input[...]
    let match = self.run(&input)
    return (match, input)
  }
}

