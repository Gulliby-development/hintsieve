struct Bucket: Equatable {
  let pattern: String
  let words: [String]
}

enum Partition {
  static func buckets(_ guess: String, _ candidates: [String]) -> [Bucket] {
    var groups: [String: [String]] = [:]

    for candidate in candidates {
      let pattern = Pattern.score(guess, candidate)
      groups[pattern, default: []].append(candidate)
    }

    return groups.keys.sorted().map { pattern in
      Bucket(pattern: pattern, words: groups[pattern] ?? [])
    }
  }
}
