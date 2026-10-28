struct Output: Equatable {
  let exit: Int32
  let text: String
}

enum Lines {
  static func rank(_ place: Int, _ row: RankRow) -> String {
    let candidate = row.isCandidate ? "yes" : "no"
    return "\(place) \(row.word) worst=\(row.worst) parts=\(row.parts) squares=\(row.squares) candidate=\(candidate)\n"
  }

  static func bucket(_ bucket: Bucket) -> String {
    "\(bucket.pattern) \(bucket.words.count): \(bucket.words.joined(separator: " "))\n"
  }

  static func turn(_ turn: Turn) -> String {
    "\(turn.number) \(turn.guess) \(turn.pattern) \(turn.remaining)\n"
  }

  static func verdict(_ verdict: Verdict) -> String {
    "\(verdict.number) \(verdict.clue.word) \(verdict.clue.pattern) \(verdict.remaining) \(verdict.status)\n"
  }
}
