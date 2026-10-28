import Testing
@testable import HintSieveCore

@Suite struct OptionsTests {
  @Test func splitsOptionsAndPositionals() throws {
    #expect(try Options.split(["a", "b"], takesValue: [:]) == Parsed(positionals: ["a", "b"], values: [:]))
    #expect(
      try Options.split(["--top", "3", "w"], takesValue: ["--top": true])
        == Parsed(positionals: ["w"], values: ["--top": "3"]))
    #expect(
      try Options.split(["w", "--top=4"], takesValue: ["--top": true])
        == Parsed(positionals: ["w"], values: ["--top": "4"]))
  }

  @Test func rejectsBadOptions() {
    #expect(throws: Failure("hintsieve: unknown option \"--bogus\"")) {
      try Options.split(["--bogus"], takesValue: [:])
    }
    #expect(throws: Failure("hintsieve: unknown option \"-x\"")) {
      try Options.split(["-x"], takesValue: [:])
    }
    #expect(throws: Failure("hintsieve: option --top needs a value")) {
      try Options.split(["--top"], takesValue: ["--top": true])
    }
  }

  @Test func topValues() throws {
    #expect(try Options.top("1") == 1)
    #expect(try Options.top("5") == 5)
    #expect(try Options.top("9999") == 9999)
    #expect(try Options.top("0007") == 7)
  }

  @Test func argumentCounts() {
    #expect(throws: Failure("hintsieve: score: wrong number of arguments")) {
      try Options.need(Parsed(positionals: ["a"], values: [:]), 2, 2, "score")
    }
  }
}
