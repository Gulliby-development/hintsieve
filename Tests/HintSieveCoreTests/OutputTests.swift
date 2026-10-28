import Testing
@testable import HintSieveCore

@Suite struct OutputTests {
  @Test func rankLines() {
    #expect(
      Lines.rank(
        1,
        RankRow(word: "crate", worst: 2, parts: 9, squares: 12, isCandidate: true)
      ) == "1 crate worst=2 parts=9 squares=12 candidate=yes\n"
    )
  }

  @Test func bucketLines() {
    #expect(Lines.bucket(Bucket(pattern: "bggbg", words: ["a", "b"])) == "bggbg 2: a b\n")
  }

  @Test func turnLines() {
    #expect(
      Lines.turn(Turn(number: 1, guess: "crate", pattern: "bbbyg", remaining: 1)) == "1 crate bbbyg 1\n"
    )
  }

  @Test func verdictLines() {
    #expect(
      Lines.verdict(
        Verdict(
          number: 2,
          clue: Clue(word: "trace", pattern: "ggggb"),
          remaining: 0,
          status: "impossible"
        )
      ) == "2 trace ggggb 0 impossible\n"
    )
  }
}
