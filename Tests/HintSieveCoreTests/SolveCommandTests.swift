import Testing
@testable import HintSieveCore

@Suite struct SolveCommandTests {
  @Test func solvesWithTheBestFirstWord() {
    #expect(
      Cli.run(["solve", "w.txt", "stone"], files: ["w.txt": Lists.five])
        == CliResult(exit: 0, out: "1 crate bbbyg 1\n2 stone ggggg 1\nsolved in 2\n", err: ""))
    #expect(
      Cli.run(["solve", "w.txt", "crane"], files: ["w.txt": Lists.five])
        == CliResult(exit: 0, out: "1 crate gggbg 1\n2 crane ggggg 1\nsolved in 2\n", err: ""))
  }

  @Test func firstOption() {
    #expect(
      Cli.run(["solve", "w.txt", "brace", "--first", "crane"], files: ["w.txt": Lists.five])
        == CliResult(exit: 0, out: "1 crane yggbg 3\n2 brace ggggg 1\nsolved in 2\n", err: ""))
  }

  @Test func hardOption() {
    #expect(
      Cli.run(["solve", "w.txt", "stone", "--hard"], files: ["w.txt": Lists.five])
        == CliResult(exit: 0, out: "1 crate bbbyg 1\n2 stone ggggg 1\nsolved in 2\n", err: ""))
  }

  @Test func threeLetters() {
    #expect(
      Cli.run(["solve", "w.txt", "rat"], files: ["w.txt": Lists.three])
        == CliResult(exit: 0, out: "1 act ybg 1\n2 rat ggg 1\nsolved in 2\n", err: ""))
  }

  @Test func badArguments() {
    #expect(
      Cli.run(["solve", "w.txt", "zebra"], files: ["w.txt": Lists.five])
        == CliResult(
          exit: 2,
          out: "",
          err: "hintsieve: answer \"zebra\" is not in the word list\n"))
    #expect(
      Cli.run(["solve", "w.txt"], files: ["w.txt": Lists.five])
        == CliResult(exit: 2, out: "", err: "hintsieve: solve: wrong number of arguments\n"))
  }

  @Test func tinyList() {
    #expect(
      Cli.run(
        ["solve", "w.txt", "bb", "--first", "aa"],
        files: ["w.txt": Array("aa\nab\nba\nbb\n".utf8)])
        == CliResult(exit: 0, out: "1 aa bb 1\n2 bb gg 1\nsolved in 2\n", err: ""))
  }
}
