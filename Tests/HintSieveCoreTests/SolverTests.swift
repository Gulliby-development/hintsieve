import Testing
@testable import HintSieveCore

@Suite struct SolverTests {
  @Test func solvesFiveLetterList() {
    #expect(
      Solver.solve(words: Lists.fiveWords, answer: "stone", first: nil, hard: false)
        == SolveResult(
          turns: [
            Turn(number: 1, guess: "crate", pattern: "bbbyg", remaining: 1),
            Turn(number: 2, guess: "stone", pattern: "ggggg", remaining: 1),
          ],
          solved: true
        )
    )
    #expect(
      Solver.solve(words: Lists.fiveWords, answer: "crane", first: nil, hard: false)
        == SolveResult(
          turns: [
            Turn(number: 1, guess: "crate", pattern: "gggbg", remaining: 1),
            Turn(number: 2, guess: "crane", pattern: "ggggg", remaining: 1),
          ],
          solved: true
        )
    )
    #expect(
      Solver.solve(words: Lists.fiveWords, answer: "brace", first: "crane", hard: false)
        == SolveResult(
          turns: [
            Turn(number: 1, guess: "crane", pattern: "yggbg", remaining: 3),
            Turn(number: 2, guess: "brace", pattern: "ggggg", remaining: 1),
          ],
          solved: true
        )
    )
  }

  @Test func solvesThreeLetterList() {
    #expect(
      Solver.solve(words: Lists.threeWords, answer: "cat", first: nil, hard: false)
        == SolveResult(
          turns: [
            Turn(number: 1, guess: "act", pattern: "yyg", remaining: 1),
            Turn(number: 2, guess: "cat", pattern: "ggg", remaining: 1),
          ],
          solved: true
        )
    )
  }

  @Test func turnLimit() {
    #expect(Solver.maxTurns == 10)
  }
}
