import Testing
@testable import HintSieveCore

@Suite struct SplitCommandTests {
  @Test func splitsTheList() {
    #expect(
      Cli.run(["split", "w.txt", "crane"], files: ["w.txt": Lists.five])
        == CliResult(
          exit: 0,
          out:
            "bbbgg 1: stone\nbbgbg 1: slate\ngggbg 1: crate\nggggg 1: crane\nyggbg 3: trace grace brace\n5 patterns, worst 3\n",
          err: ""))
    #expect(
      Cli.run(["split", "w.txt", "slate"], files: ["w.txt": Lists.five])
        == CliResult(
          exit: 0,
          out:
            "bbgbg 3: crane grace brace\nbbggg 1: crate\nbbgyg 1: trace\ngbbyg 1: stone\nggggg 1: slate\n5 patterns, worst 3\n",
          err: ""))
  }

  @Test func threeLetters() {
    #expect(
      Cli.run(["split", "w.txt", "cat"], files: ["w.txt": Lists.three])
        == CliResult(
          exit: 0,
          out: "bgg 1: rat\nggb 1: car\nggg 1: cat\nygy 1: tac\nyyb 1: arc\nyyg 1: act\n6 patterns, worst 1\n",
          err: ""))
  }

  @Test func emptyCandidates() {
    #expect(
      Cli.run(
        ["split", "w.txt", "crane", "crane:bbbbb", "stone:bbbbb"],
        files: ["w.txt": Lists.five])
        == CliResult(exit: 0, out: "0 patterns, worst 0\n", err: ""))
  }

  @Test func badArguments() {
    #expect(
      Cli.run(["split", "w.txt"], files: ["w.txt": Lists.five])
        == CliResult(exit: 2, out: "", err: "hintsieve: split: wrong number of arguments\n"))
    #expect(
      Cli.run(["split", "w.txt", "Crane"], files: ["w.txt": Lists.five])
        == CliResult(
          exit: 2,
          out: "",
          err: "hintsieve: bad word \"Crane\": need 5 lowercase letters\n"))
  }
}
