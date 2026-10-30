import Testing

@testable import HintSieveCore

@Suite struct FilterCountTests {
  @Test func printsOnlyTheCount() {
    #expect(
      Cli.run(["filter", "w.txt", "--count"], files: ["w.txt": Lists.five])
        == CliResult(exit: 0, out: "7 of 7\n", err: ""))
    #expect(
      Cli.run(["filter", "w.txt", "crane:yggbg", "--count"], files: ["w.txt": Lists.five])
        == CliResult(exit: 0, out: "3 of 7\n", err: ""))
    #expect(
      Cli.run(["filter", "w.txt", "trace:bgggg", "--count"], files: ["w.txt": Lists.five])
        == CliResult(exit: 0, out: "2 of 7\n", err: ""))
    #expect(
      Cli.run(["filter", "w.txt", "cat:bgg", "--count"], files: ["w.txt": Lists.three])
        == CliResult(exit: 0, out: "1 of 6\n", err: ""))
  }

  @Test func theFlagMayStandAnywhereAndRepeat() {
    let expected = CliResult(exit: 0, out: "3 of 7\n", err: "")
    #expect(
      Cli.run(["filter", "--count", "w.txt", "crane:yggbg"], files: ["w.txt": Lists.five])
        == expected)
    #expect(
      Cli.run(["filter", "w.txt", "--count", "crane:yggbg"], files: ["w.txt": Lists.five])
        == expected)
    #expect(
      Cli.run(
        ["filter", "--count", "w.txt", "--count", "crane:yggbg", "--count"],
        files: ["w.txt": Lists.five]) == expected)
  }

  @Test func exitsOneWithoutCandidates() {
    #expect(
      Cli.run(["filter", "w.txt", "crane:bbbbb", "stone:bbbbb", "--count"], files: ["w.txt": Lists.five])
        == CliResult(exit: 1, out: "0 of 7\n", err: ""))
  }

  @Test func readsStandardInput() {
    #expect(
      Cli.run(["filter", "-", "--count", "crane:yggbg"], stdin: Lists.five)
        == CliResult(exit: 0, out: "3 of 7\n", err: ""))
    #expect(
      Cli.run(["filter", "-", "--count"], stdin: [0xFF], files: [:])
        == CliResult(exit: 2, out: "", err: "hintsieve: <stdin>: input is not valid UTF-8\n"))
  }

  @Test func keepsTheOtherErrors() {
    #expect(
      Cli.run(["filter", "w.txt", "crane", "--count"], files: ["w.txt": Lists.five])
        == CliResult(exit: 2, out: "", err: "hintsieve: bad clue \"crane\": expected WORD:PATTERN\n"))
    #expect(
      Cli.run(["filter", "w.txt", "--count"], files: ["w.txt": Array("crane\nSlate\n".utf8)])
        == CliResult(
          exit: 2,
          out: "",
          err: "hintsieve: w.txt:2: not a lowercase word of 2 to 8 letters\n"))
    #expect(
      Cli.run(["filter", "--count"], files: [:])
        == CliResult(exit: 2, out: "", err: "hintsieve: filter: wrong number of arguments\n"))
  }

  @Test func theFlagTakesNoValueAndBelongsToFilter() {
    #expect(
      Cli.run(["filter", "w.txt", "--count=1"], files: ["w.txt": Lists.five])
        == CliResult(exit: 2, out: "", err: "hintsieve: option --count takes no value\n"))
    #expect(
      Cli.run(["filter", "w.txt", "--counts"], files: ["w.txt": Lists.five])
        == CliResult(exit: 2, out: "", err: "hintsieve: unknown option \"--counts\"\n"))
    #expect(
      Cli.run(["rank", "w.txt", "--count"], files: ["w.txt": Lists.five])
        == CliResult(exit: 2, out: "", err: "hintsieve: unknown option \"--count\"\n"))
    #expect(
      Cli.run(["split", "w.txt", "crane", "--count"], files: ["w.txt": Lists.five])
        == CliResult(exit: 2, out: "", err: "hintsieve: unknown option \"--count\"\n"))
    #expect(
      Cli.run(["solve", "w.txt", "stone", "--count"], files: ["w.txt": Lists.five])
        == CliResult(exit: 2, out: "", err: "hintsieve: unknown option \"--count\"\n"))
  }
}
