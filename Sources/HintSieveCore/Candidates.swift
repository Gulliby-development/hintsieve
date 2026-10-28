enum Candidates {
  static func keep(_ words: [String], _ clue: Clue) -> [String] {
    words.filter { Pattern.score(clue.word, $0) == clue.pattern }
  }

  static func apply(_ words: [String], clues: [String]) throws -> [String] {
    let originalSize = words.first?.utf8.count ?? 0
    var candidates = words

    for text in clues {
      let clue = try Clue.parse(text, size: originalSize)
      candidates = keep(candidates, clue)
    }

    return candidates
  }
}
