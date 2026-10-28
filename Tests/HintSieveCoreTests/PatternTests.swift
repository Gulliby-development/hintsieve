import Testing
@testable import HintSieveCore

@Suite struct PatternTests {
  @Test func allGreenAndAllBlack() {
    #expect(Pattern.score("crane", "crane") == "ggggg")
    #expect(Pattern.score("crane", "ghost") == "bbbbb")
  }

  @Test func yellowLetters() {
    #expect(Pattern.score("crane", "slate") == "bbgbg")
    #expect(Pattern.score("slate", "crane") == "bbgbg")
    #expect(Pattern.score("trace", "crate") == "yggyg")
  }

  @Test func repeatedLetters() {
    #expect(Pattern.score("speed", "abide") == "bbyby")
    #expect(Pattern.score("abide", "speed") == "bbbyy")
    #expect(Pattern.score("allow", "local") == "yyyyb")
    #expect(Pattern.score("eerie", "where") == "ybybg")
  }

  @Test func otherLengths() {
    #expect(Pattern.score("cat", "act") == "yyg")
    #expect(Pattern.score("tac", "cat") == "ygy")
  }

  @Test func allGreenCheck() {
    #expect(Pattern.isAllGreen("ggggg"))
    #expect(Pattern.isAllGreen("g"))
  }
}
