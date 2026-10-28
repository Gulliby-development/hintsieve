import Testing
@testable import HintSieveCore

@Suite struct CheckCommandTests {
  @Test func acceptsAPossibleLog() {
    #expect(
      Cli.run(
        ["check", "w.txt", "log.txt"],
        files: [
          "w.txt": Lists.five,
          "log.txt": Array("slate:gbbyg\nstone:ggggg\n".utf8),
        ])
        == CliResult(exit: 0, out: "1 slate gbbyg 1 ok\n2 stone ggggg 1 ok\n", err: ""))
  }

  @Test func reportsImpossibleLines() {
    #expect(
      Cli.run(
        ["check", "w.txt", "log.txt"],
        files: [
          "w.txt": Lists.five,
          "log.txt": Array("crane:bbybg\ntrace:ggggb\n".utf8),
        ])
        == CliResult(
          exit: 1,
          out: "1 crane bbybg 0 impossible\n2 trace ggggb 0 impossible\n",
          err: ""))
  }

  @Test func hardModeOption() {
    #expect(
      Cli.run(
        ["check", "w.txt", "log.txt", "--hard"],
        files: [
          "w.txt": Lists.five,
          "log.txt": Array("slate:gbbyg\ngrace:bbbbg\n".utf8),
        ])
        == CliResult(exit: 1, out: "1 slate gbbyg 1 ok\n2 grace bbbbg 1 hard\n", err: ""))
    #expect(
      Cli.run(
        ["check", "w.txt", "log.txt"],
        files: [
          "w.txt": Lists.five,
          "log.txt": Array("slate:gbbyg\ngrace:bbbbg\n".utf8),
        ])
        == CliResult(exit: 0, out: "1 slate gbbyg 1 ok\n2 grace bbbbg 1 ok\n", err: ""))
  }

  @Test func badLogs() {
    #expect(
      Cli.run(
        ["check", "w.txt", "log.txt"],
        files: ["w.txt": Lists.five, "log.txt": Array("crane\n".utf8)])
        == CliResult(
          exit: 2,
          out: "",
          err: "hintsieve: log.txt:1: not a clue of the form WORD:PATTERN\n"))
  }

  @Test func badArguments() {
    #expect(
      Cli.run(["check", "w.txt"], files: ["w.txt": Lists.five])
        == CliResult(exit: 2, out: "", err: "hintsieve: check: wrong number of arguments\n"))
    #expect(
      Cli.run(["check", "w.txt", "-"], files: ["w.txt": Lists.five])
        == CliResult(
          exit: 2,
          out: "",
          err: "hintsieve: check reads its log from a file, not from stdin\n"))
  }

  @Test func readsWordsFromStandardInput() {
    #expect(
      Cli.run(
        ["check", "-", "log.txt"],
        stdin: Lists.five,
        files: ["log.txt": Array("slate:gbbyg\nstone:ggggg\n".utf8)])
        == CliResult(exit: 0, out: "1 slate gbbyg 1 ok\n2 stone ggggg 1 ok\n", err: ""))
  }
}
