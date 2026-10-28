import Testing
@testable import HintSieveCore

@Suite struct FilterCommandTests {
  @Test func filtersByClues() {
    #expect(
      Cli.run(["filter", "w.txt"], files: ["w.txt": Lists.five])
        == CliResult(
          exit: 0,
          out: "crane\nslate\ntrace\ncrate\ngrace\nbrace\nstone\n7 of 7\n",
          err: ""))
    #expect(
      Cli.run(["filter", "w.txt", "crane:yggbg"], files: ["w.txt": Lists.five])
        == CliResult(exit: 0, out: "trace\ngrace\nbrace\n3 of 7\n", err: ""))
    #expect(
      Cli.run(["filter", "w.txt", "trace:bgggg"], files: ["w.txt": Lists.five])
        == CliResult(exit: 0, out: "grace\nbrace\n2 of 7\n", err: ""))
  }

  @Test func exitsOneWithoutCandidates() {
    #expect(
      Cli.run(["filter", "w.txt", "crane:bbbbb", "stone:bbbbb"], files: ["w.txt": Lists.five])
        == CliResult(exit: 1, out: "0 of 7\n", err: ""))
  }

  @Test func threeLetterList() {
    #expect(
      Cli.run(["filter", "w.txt", "cat:bgg"], files: ["w.txt": Lists.three])
        == CliResult(exit: 0, out: "rat\n1 of 6\n", err: ""))
  }

  @Test func badClues() {
    #expect(
      Cli.run(["filter", "w.txt", "crane"], files: ["w.txt": Lists.five])
        == CliResult(exit: 2, out: "", err: "hintsieve: bad clue \"crane\": expected WORD:PATTERN\n"))
    #expect(
      Cli.run(["filter", "w.txt", "crane:bbyb"], files: ["w.txt": Lists.five])
        == CliResult(
          exit: 2,
          out: "",
          err: "hintsieve: bad clue \"crane:bbyb\": pattern must be 5 characters of g, y, b\n"))
  }

  @Test func listProblems() {
    #expect(
      Cli.run(["filter", "w.txt"], files: ["w.txt": Array("crane\nSlate\n".utf8)])
        == CliResult(
          exit: 2,
          out: "",
          err: "hintsieve: w.txt:2: not a lowercase word of 2 to 8 letters\n"))
    #expect(
      Cli.run(["filter", "w.txt"], files: ["w.txt": Array("crane\nslat\n".utf8)])
        == CliResult(
          exit: 2,
          out: "",
          err: "hintsieve: w.txt:2: word has 4 letters, expected 5\n"))
  }

  @Test func readsStandardInput() {
    #expect(
      Cli.run(["filter", "-", "crane:yggbg"], stdin: Lists.five)
        == CliResult(exit: 0, out: "trace\ngrace\nbrace\n3 of 7\n", err: ""))
    #expect(
      Cli.run(["filter", "-"], stdin: [0xFF], files: [:])
        == CliResult(exit: 2, out: "", err: "hintsieve: <stdin>: input is not valid UTF-8\n"))
  }
}
