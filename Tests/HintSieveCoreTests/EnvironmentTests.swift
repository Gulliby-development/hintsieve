import Testing
@testable import HintSieveCore

@Suite struct EnvironmentTests {
  @Test func standardInput() throws {
    let env = Environment(stdin: [1, 2], read: { _ in nil })
    #expect(try env.source("-").bytes == [1, 2])
    #expect(try env.source("-").label == "<stdin>")
  }

  @Test func files() throws {
    let env = Environment(stdin: [], read: { $0 == "w.txt" ? [97] : nil })
    #expect(try env.source("w.txt").bytes == [97])
    #expect(try env.source("w.txt").label == "w.txt")
    #expect(throws: Failure("hintsieve: missing.txt: cannot read file")) {
      try env.source("missing.txt")
    }
  }
}
