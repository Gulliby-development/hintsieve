enum SplitCommand {
  static func run(_ args: [String], _ env: Environment) throws -> Output {
    let parsed = try Options.split(args, takesValue: [:])
    try Options.need(parsed, 2, nil, "split")

    let source = try env.source(parsed.positionals[0])
    let words = try WordList.parse(source.bytes, label: source.label)
    let guess = parsed.positionals[1]
    let wordLength = words[0].utf8.count

    guard Letters.isWord(guess, min: wordLength, max: wordLength) else {
      throw Failure("hintsieve: bad word \"\(guess)\": need \(wordLength) lowercase letters")
    }

    let clues = Array(parsed.positionals.dropFirst(2))
    let candidates = try Candidates.apply(words, clues: clues)
    let buckets = Partition.buckets(guess, candidates)
    let bucketLines = buckets.map { Lines.bucket($0) }.joined()
    let worst = buckets.map { $0.words.count }.max() ?? 0
    let summary = "\(buckets.count) patterns, worst \(worst)\n"

    return Output(exit: 0, text: bucketLines + summary)
  }
}
