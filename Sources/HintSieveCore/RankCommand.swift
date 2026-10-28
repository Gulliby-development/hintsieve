enum RankCommand {
  static func run(_ args: [String], _ env: Environment) throws -> Output {
    let parsed = try Options.split(args, takesValue: ["--top": true])
    try Options.need(parsed, 1, nil, "rank")

    let source = try env.source(parsed.positionals[0])
    let words = try WordList.parse(source.bytes, label: source.label)
    let top = try parsed.values["--top"].map(Options.top) ?? 5
    let candidates = try Candidates.apply(words, clues: Array(parsed.positionals.dropFirst()))

    guard !candidates.isEmpty else {
      throw Failure("hintsieve: no candidates", code: 1)
    }

    let rows = Ranking.rank(pool: words, candidates: candidates)
    var text = "candidates: \(candidates.count)\n"
    for (index, row) in rows.prefix(top).enumerated() {
      text += Lines.rank(index + 1, row)
    }

    return Output(exit: 0, text: text)
  }
}
