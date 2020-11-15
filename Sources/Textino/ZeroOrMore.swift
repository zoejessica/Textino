import Foundation

public extension Parser {
  func zeroOrMore(separatedBy separator: Parser<Void> = "") -> Parser<[Output]> {
    Parser<[Output]> { input in
      var rest = input
      var matches: [Output] = []
      while let match = self.run(&input) {
        rest = input
        matches.append(match)
        if separator.run(&input) == nil {
          return matches
        }
      }
      input = rest
      return matches
    }
  }
  
  func oneOrMore(separatedBy separator: Parser<Void> = "") -> Parser<[Output]> {
    Parser<[Output]> { input in
      var rest = input
      var matches: [Output] = []
      while let match = self.run(&input) {
        rest = input
        matches.append(match)
        if matches.count > 0 && separator.run(&input) == nil {
          return matches
        }
      }
      input = rest
      if matches.count > 0 {
        return matches
      } else {
        return nil
      }
    }
  }
}


