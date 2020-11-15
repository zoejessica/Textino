import Foundation

public extension Parser {
  func map<NewOutput>(_ f: @escaping (Output) -> NewOutput) -> Parser<NewOutput> {
    Parser<NewOutput>() { input in
      self.run(&input).map(f)
    }
  }
}

public extension Parser {
  func flatMap<NewOutput>(_ f: @escaping (Output) -> Parser<NewOutput>) -> Parser<NewOutput> {
    Parser<NewOutput>() { input in
      let original = input
      let output = self.run(&input)
      let newParser = output.map(f)
      guard let newOutput = newParser?.run(&input) else {
        input = original
        return nil
      }
      return newOutput
    }
  }
}

// MARK: Zips

public func zip<A, B>(_ pA: Parser<A>, _ pB: Parser<B>) -> Parser<(A, B)> {
  Parser<(A, B)>() { input in
    let original = input
    guard let outputA = pA.run(&input) else { return nil }
    guard let outputB = pB.run(&input) else {
      input = original
      return nil
    }
    return (outputA, outputB)
  }
}

public func zip<A, B, C>(_ pA: Parser<A>, _ pB: Parser<B>, _ pC: Parser<C>) -> Parser<(A, B, C)> {
  zip(pA, zip(pB, pC))
    .map { a, bc in (a, bc.0, bc.1) }
}

public func zip<A, B, C, D>(_ pA: Parser<A>, _ pB: Parser<B>, _ pC: Parser<C>, _ pD: Parser<D>) -> Parser<(A, B, C, D)> {
  zip(pA,
    zip(pB, zip(pC, pD))
    .map { b, cd in (b, cd.0, cd.1) })
    .map { a, bcd in (a, bcd.0, bcd.1, bcd.2) }
}

public func zip<A, B, C, D, E>(_ pA: Parser<A>, _ pB: Parser<B>, _ pC: Parser<C>, _ pD: Parser<D>, _ pE: Parser<E>) -> Parser<(A, B, C, D, E)> {
  zip(pA,
    zip(pB,
      zip(pC, zip(pD, pE))
      .map { c, de in (c, de.0, de.1) })
    .map { b, cde in (b, cde.0, cde.1, cde.2) })
  .map { a, bcde in (a, bcde.0, bcde.1, bcde.2, bcde.3) }
}

