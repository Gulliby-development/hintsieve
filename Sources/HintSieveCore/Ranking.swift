struct RankRow: Equatable {
  let word: String
  let worst: Int
  let parts: Int
  let squares: Int
  let isCandidate: Bool
}

enum Ranking {
  static func rank(pool: [String], candidates: [String]) -> [RankRow] {
    let candidateSet = Set(candidates)
    let rows = pool.map { word in
      let buckets = Partition.buckets(word, candidates)
      let sizes = buckets.map { $0.words.count }
      let worst = sizes.max() ?? 0
      let squares = sizes.reduce(0) { total, size in
        total + size * size
      }

      return RankRow(
        word: word,
        worst: worst,
        parts: buckets.count,
        squares: squares,
        isCandidate: candidateSet.contains(word)
      )
    }

    return rows.sorted { left, right in
      if left.worst != right.worst {
        return left.worst < right.worst
      }
      if left.squares != right.squares {
        return left.squares < right.squares
      }
      if left.isCandidate != right.isCandidate {
        return left.isCandidate
      }
      return left.word < right.word
    }
  }
}
