import Testing
@testable import HintSieveCore

@Suite struct TranscriptTests {
  @Test func judgesEachLine() {
    #expect(
      Transcript.check(
        words: Lists.fiveWords,
        clues: [Clue(word: "crane", pattern: "yggbg")],
        hard: false
      ) == [Verdict(number: 1, clue: Clue(word: "crane", pattern: "yggbg"), remaining: 3, status: "ok")]
    )
    #expect(
      Transcript.check(
        words: Lists.fiveWords,
        clues: [
          Clue(word: "crane", pattern: "bbbgg"),
          Clue(word: "slate", pattern: "gbbyg"),
        ],
        hard: false
      ) == [
        Verdict(number: 1, clue: Clue(word: "crane", pattern: "bbbgg"), remaining: 1, status: "ok"),
        Verdict(number: 2, clue: Clue(word: "slate", pattern: "gbbyg"), remaining: 1, status: "ok"),
      ]
    )
    #expect(
      Transcript.check(
        words: Lists.fiveWords,
        clues: [
          Clue(word: "slate", pattern: "gbbyg"),
          Clue(word: "grace", pattern: "bbbbg"),
        ],
        hard: true
      ) == [
        Verdict(number: 1, clue: Clue(word: "slate", pattern: "gbbyg"), remaining: 1, status: "ok"),
        Verdict(number: 2, clue: Clue(word: "grace", pattern: "bbbbg"), remaining: 1, status: "hard"),
      ]
    )
  }
}
