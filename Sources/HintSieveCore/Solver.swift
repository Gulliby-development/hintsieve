struct Turn: Equatable {
  let number: Int
  let guess: String
  let pattern: String
  let remaining: Int
}

struct SolveResult: Equatable {
  let turns: [Turn]
  let solved: Bool
}

enum Solver {
  static let maxTurns = 10

  static func solve(words: [String], answer: String, first: String?, hard: Bool) -> SolveResult {
    var candidates = words
    var turns: [Turn] = []

    for number in 1...maxTurns {
      let guess: String
      if number == 1, let first {
        guess = first
      } else {
        let pool = hard && number > 1 ? candidates : words
        guard let rankedGuess = Ranking.rank(pool: pool, candidates: candidates).first else {
          return SolveResult(turns: turns, solved: false)
        }
        guess = rankedGuess.word
      }

      let pattern = Pattern.score(guess, answer)
      candidates = Candidates.keep(candidates, Clue(word: guess, pattern: pattern))
      turns.append(Turn(number: number, guess: guess, pattern: pattern, remaining: candidates.count))

      if Pattern.isAllGreen(pattern) {
        return SolveResult(turns: turns, solved: true)
      }
    }

    return SolveResult(turns: turns, solved: false)
  }
}
