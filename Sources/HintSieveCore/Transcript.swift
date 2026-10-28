struct Verdict: Equatable {
  let number: Int
  let clue: Clue
  let remaining: Int
  let status: String
}

enum Transcript {
  static func check(words: [String], clues: [Clue], hard: Bool) -> [Verdict] {
    var candidates = words
    var history: [Clue] = []
    var verdicts: [Verdict] = []

    for (index, clue) in clues.enumerated() {
      candidates = Candidates.keep(candidates, clue)

      let status: String
      if candidates.isEmpty {
        status = "impossible"
      } else if hard && history.contains(where: { Pattern.score($0.word, clue.word) != $0.pattern }) {
        status = "hard"
      } else {
        status = "ok"
      }

      verdicts.append(
        Verdict(number: index + 1, clue: clue, remaining: candidates.count, status: status)
      )
      history.append(clue)
    }

    return verdicts
  }
}
