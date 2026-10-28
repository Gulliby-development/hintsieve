import Testing
@testable import HintSieveCore

@Suite struct RankCommandTests {
  @Test func defaultTopFive() {
    #expect(
      Cli.run(["rank", "w.txt"], files: ["w.txt": Lists.five])
        == CliResult(
          exit: 0,
          out:
            "candidates: 7\n1 crate worst=2 parts=6 squares=9 candidate=yes\n2 trace worst=2 parts=6 squares=9 candidate=yes\n3 brace worst=2 parts=5 squares=11 candidate=yes\n4 grace worst=2 parts=5 squares=11 candidate=yes\n5 stone worst=2 parts=5 squares=11 candidate=yes\n",
          err: ""))
    #expect(
      Cli.run(["rank", "w.txt", "crane:yggbg"], files: ["w.txt": Lists.five])
        == CliResult(
          exit: 0,
          out:
            "candidates: 3\n1 brace worst=2 parts=2 squares=5 candidate=yes\n2 grace worst=2 parts=2 squares=5 candidate=yes\n3 trace worst=2 parts=2 squares=5 candidate=yes\n4 crate worst=2 parts=2 squares=5 candidate=no\n5 slate worst=2 parts=2 squares=5 candidate=no\n",
          err: ""))
  }

  @Test func topOption() {
    #expect(
      Cli.run(["rank", "w.txt", "--top", "1"], files: ["w.txt": Lists.five])
        == CliResult(
          exit: 0,
          out: "candidates: 7\n1 crate worst=2 parts=6 squares=9 candidate=yes\n",
          err: ""))
    #expect(
      Cli.run(["rank", "w.txt", "--top=2"], files: ["w.txt": Lists.five])
        == CliResult(
          exit: 0,
          out:
            "candidates: 7\n1 crate worst=2 parts=6 squares=9 candidate=yes\n2 trace worst=2 parts=6 squares=9 candidate=yes\n",
          err: ""))
  }

  @Test func threeLetters() {
    #expect(
      Cli.run(["rank", "w.txt", "--top", "3"], files: ["w.txt": Lists.three])
        == CliResult(
          exit: 0,
          out:
            "candidates: 6\n1 act worst=1 parts=6 squares=6 candidate=yes\n2 arc worst=1 parts=6 squares=6 candidate=yes\n3 car worst=1 parts=6 squares=6 candidate=yes\n",
          err: ""))
  }

  @Test func noCandidates() {
    #expect(
      Cli.run(
        ["rank", "w.txt", "crane:bbbbb", "stone:bbbbb"], files: ["w.txt": Lists.five])
        == CliResult(exit: 1, out: "", err: "hintsieve: no candidates\n"))
  }

  @Test func badOptions() {
    #expect(
      Cli.run(["rank", "w.txt", "--top", "0"], files: ["w.txt": Lists.five])
        == CliResult(
          exit: 2,
          out: "",
          err: "hintsieve: bad --top value \"0\": expected an integer from 1 to 9999\n"))
    #expect(
      Cli.run(["rank", "w.txt", "--top", "x"], files: ["w.txt": Lists.five])
        == CliResult(
          exit: 2,
          out: "",
          err: "hintsieve: bad --top value \"x\": expected an integer from 1 to 9999\n"))
  }
}
