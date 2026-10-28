import Testing
@testable import HintSieveCore

@Suite struct ScoreCommandTests {
  @Test func printsThePattern() {
    #expect(
      Cli.run(["score", "crane", "slate"])
        == CliResult(exit: 0, out: "bbgbg\n", err: ""))
    #expect(
      Cli.run(["score", "speed", "abide"])
        == CliResult(exit: 0, out: "bbyby\n", err: ""))
    #expect(
      Cli.run(["score", "ab", "ab"])
        == CliResult(exit: 0, out: "gg\n", err: ""))
  }

  @Test func rejectsBadArguments() {
    #expect(
      Cli.run(["score", "Crane", "slate"])
        == CliResult(
          exit: 2, out: "", err: "hintsieve: bad word \"Crane\": need 2 to 8 lowercase letters\n"))
    #expect(
      Cli.run(["score", "crane", "sl"])
        == CliResult(exit: 2, out: "", err: "hintsieve: length mismatch: 5 and 2\n"))
    #expect(
      Cli.run(["score", "c", "c"])
        == CliResult(exit: 2, out: "", err: "hintsieve: bad word \"c\": need 2 to 8 lowercase letters\n"))
  }
}
