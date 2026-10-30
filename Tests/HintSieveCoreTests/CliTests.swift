import Testing
@testable import HintSieveCore

@Suite struct CliTests {
  @Test func helpAndUsage() {
    #expect(
      Cli.run(["help"])
        == CliResult(
          exit: 0,
          out:
            "usage: hintsieve COMMAND [ARGS]\n  score GUESS ANSWER\n  filter WORDS [--count] [CLUE...]\n  rank WORDS [--top N] [CLUE...]\n  split WORDS GUESS [CLUE...]\n  solve WORDS ANSWER [--first WORD] [--hard]\n  check WORDS LOG [--hard]\n",
          err: ""))
    #expect(
      Cli.run(["-h"])
        == CliResult(
          exit: 0,
          out:
            "usage: hintsieve COMMAND [ARGS]\n  score GUESS ANSWER\n  filter WORDS [--count] [CLUE...]\n  rank WORDS [--top N] [CLUE...]\n  split WORDS GUESS [CLUE...]\n  solve WORDS ANSWER [--first WORD] [--hard]\n  check WORDS LOG [--hard]\n",
          err: ""))
    #expect(
      Cli.run([])
        == CliResult(
          exit: 2,
          out: "",
          err:
            "usage: hintsieve COMMAND [ARGS]\n  score GUESS ANSWER\n  filter WORDS [--count] [CLUE...]\n  rank WORDS [--top N] [CLUE...]\n  split WORDS GUESS [CLUE...]\n  solve WORDS ANSWER [--first WORD] [--hard]\n  check WORDS LOG [--hard]\n"
        ))
    #expect(
      Cli.run(["frob"])
        == CliResult(exit: 2, out: "", err: "hintsieve: unknown command \"frob\"\n"))
  }

  @Test func commandsReachTheirImplementations() {
    #expect(
      Cli.run(["score", "crane", "slate"])
        == CliResult(exit: 0, out: "bbgbg\n", err: ""))
    #expect(
      Cli.run(["filter", "w.txt", "crane:yggbg"], files: ["w.txt": Lists.five])
        == CliResult(exit: 0, out: "trace\ngrace\nbrace\n3 of 7\n", err: ""))
  }

  @Test func readClosure() {
    #expect(
      Cli.run(["filter", "any"], read: { _ in Array("ab\n".utf8) })
        == CliResult(exit: 0, out: "ab\n1 of 1\n", err: ""))
  }
}
