import Testing
@testable import HintSieveCore

@Suite struct CandidatesTests {
  @Test func keepFiltersByScore() {
    #expect(Candidates.keep(Lists.fiveWords, Clue(word: "crane", pattern: "bbybg")) == [])
    #expect(Candidates.keep(Lists.fiveWords, Clue(word: "crane", pattern: "ggggg")) == ["crane"])
  }

  @Test func applyChainsClues() throws {
    #expect(
      try Candidates.apply(Lists.fiveWords, clues: []) == [
        "crane", "slate", "trace", "crate", "grace", "brace", "stone",
      ])
    #expect(try Candidates.apply(Lists.fiveWords, clues: ["crane:yggbg"]) == ["trace", "grace", "brace"])
  }

  @Test func applyRejectsBadClues() {
    #expect(throws: Failure("hintsieve: bad clue \"crane\": expected WORD:PATTERN")) {
      try Candidates.apply(Lists.fiveWords, clues: ["crane"])
    }
    #expect(throws: Failure("hintsieve: bad clue \"crane:bbyb\": pattern must be 5 characters of g, y, b")) {
      try Candidates.apply(Lists.fiveWords, clues: ["crane:bbyb"])
    }
  }
}
