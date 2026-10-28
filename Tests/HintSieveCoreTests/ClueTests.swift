import Testing
@testable import HintSieveCore

@Suite struct ClueTests {
  @Test func parsesClues() throws {
    #expect(try Clue.parse("crane:yggbg", size: 5) == Clue(word: "crane", pattern: "yggbg"))
    #expect(try Clue.parse("ab:gy", size: 2) == Clue(word: "ab", pattern: "gy"))
  }

  @Test func rejectsBadClues() {
    #expect(throws: Failure("hintsieve: bad clue \"crane\": expected WORD:PATTERN")) {
      try Clue.parse("crane", size: 5)
    }
    #expect(throws: Failure("hintsieve: bad clue \"crane:bbybg:g\": expected WORD:PATTERN")) {
      try Clue.parse("crane:bbybg:g", size: 5)
    }
    #expect(throws: Failure("hintsieve: bad clue \":\": word must be 5 lowercase letters")) {
      try Clue.parse(":", size: 5)
    }
    #expect(throws: Failure("hintsieve: bad clue \"crane:\": pattern must be 5 characters of g, y, b")) {
      try Clue.parse("crane:", size: 5)
    }
    #expect(throws: Failure("hintsieve: bad clue \":bbybg\": word must be 5 lowercase letters")) {
      try Clue.parse(":bbybg", size: 5)
    }
  }
}
